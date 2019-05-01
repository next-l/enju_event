class EventImportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include ImportFile
  scope :not_imported, -> {in_state(:pending)}
  scope :stucked, -> {in_state(:pending).where('event_import_files.created_at < ?', 1.hour.ago)}

  has_one_attached :event_import
  belongs_to :user, validate: true
  belongs_to :default_library, class_name: 'Library', optional: true
  belongs_to :default_event_category, class_name: 'EventCategory', optional: true
  has_many :event_import_results

  has_many :event_import_file_transitions, autosave: false

  attr_accessor :mode

  def state_machine
    EventImportFileStateMachine.new(self, transition_class: EventImportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def import
    transition_to!(:started)
    num = { imported: 0, failed: 0 }
    rows = open_import_file
    check_field(rows.headers.join('\t'))
    row_num = 1

    rows.each do |row|
      row_num += 1
      next if row['dummy'].to_s.strip.present?
      event_import_result = EventImportResult.new
      event_import_result.assign_attributes({ event_import_file_id: id, body: row.fields.join("\t") })
      event_import_result.save!

      event = Event.new
      event.name = row['name'].to_s.strip
      event.display_name = row['display_name']
      event.note = row['note']
      event.start_at = Time.zone.parse(row['start_at']) if row['start_at'].present?
      event.end_at = Time.zone.parse(row['end_at']) if row['end_at'].present?
      category = row['event_category'].to_s.strip
      if %w(t true TRUE).include?(row['all_day'].to_s.strip)
        event.all_day = true
      else
        event.all_day = false
      end
      library = Library.where(name: row['library']).first
      library = default_library || Library.web if library.blank?
      event.library = library
      event_category = EventCategory.where(name: row['event_category']).first
      event_category = default_event_category if event_category.blank?
      event.event_category = event_category

      if event.save
        event_import_result.event = event
        num[:imported] += 1
        if row_num % 50 == 0
          Sunspot.commit
          GC.start
        end
      else
        num[:failed] += 1
      end
      event_import_result.save!
    end
    Sunspot.commit
    transition_to!(:completed)
    mailer = EventImportMailer.completed(self)
    send_message(mailer)
    num
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    save
    transition_to!(:failed)
    mailer = EventImportMailer.failed(self)
    send_message(mailer)
    raise e
  end

  def modify
    transition_to!(:started)
    rows = open_import_file
    check_field(rows.first)
    row_num = 1

    rows.each do |row|
      row_num += 1
      next if row['dummy'].to_s.strip.present?
      event = Event.find(row['id'].to_s.strip)
      event_category = EventCategory.where(name: row['event_category'].to_s.strip).first
      event.event_category = event_category if event_category
      library = Library.where(name: row['library'].to_s.strip).first
      event.library = library if library
      event.name = row['name'] if row['name'].to_s.strip.present?
      event.start_at = Time.zone.parse(row['start_at']) if row['start_at'].present?
      event.end_at = Time.zone.parse(row['end_at']) if row['end_at'].present?
      event.note = row['note'] if row['note'].to_s.strip.present?
      if %w(t true TRUE).include?(row['all_day'].to_s.strip)
        event.all_day = true
      else
        event.all_day = false
      end
      event.save!
    end
    transition_to!(:completed)
    mailer = EventImportMailer.completed(self)
    send_message(mailer)
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    save
    transition_to!(:failed)
    mailer = EventImportMailer.failed(self)
    send_message(mailer)
    raise e
  end

  def remove
    transition_to!(:started)
    rows = open_import_file
    row_num = 1

    rows.each do |row|
      row_num += 1
      next if row['dummy'].to_s.strip.present?
      event = Event.find(row['id'].to_s.strip)
      event.picture_files.destroy_all # workaround
      event.reload
      event.destroy
    end
    transition_to!(:completed)
    mailer = EventImportMailer.completed(self)
    send_message(mailer)
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    save
    transition_to!(:failed)
    mailer = EventImportMailer.failed(self)
    send_message(mailer)
    raise e
  end

  def self.import
    EventImportFile.not_imported.each(&:import_start)
  rescue
    Rails.logger.info "#{Time.zone.now} importing events failed!"
  end

  private
  def self.transition_class
    EventImportFileTransition
  end

  def self.initial_state
    :pending
  end

  def open_import_file
    byte = ActiveStorage::Blob.service.download(event_import.key)
    if defined?(CharlockHolmes)
      string = CharlockHolmes::Converter.convert(byte, user_encoding || byte.detect_encoding[:encoding], 'utf-8')
    else
      string = NKF.nkf("--ic=#{user_encoding || NKF.guess(byte).to_s} --oc=utf-8", byte)
    end

    rows = CSV.parse(string, col_sep: "\t", encoding: 'utf-8', headers: true)
    header_columns = %w(
      id name display_name library event_category start_at end_at all_day note dummy
    )
    ignored_columns = rows.headers - header_columns
    unless ignored_columns.empty?
      self.error_message = I18n.t('import.following_column_were_ignored', column: ignored_columns.join(', '))
      save!
    end
    event_import_result = EventImportResult.new
    event_import_result.assign_attributes({ event_import_file_id: id, body: rows.headers.join("\t") })
    event_import_result.save!
    rows
  end

  def check_field(field)
    if [field['name']].reject{|f| f.to_s.strip == ""}.empty?
      raise "You should specify a name in the first line"
    end
    if [field['start_at'], field['end_at']].reject{|field| field.to_s.strip == ""}.empty?
      raise "You should specify dates in the first line"
    end
  end
end

# == Schema Information
#
# Table name: event_import_files
#
#  id                        :bigint           not null, primary key
#  user_id                   :bigint
#  note                      :text
#  executed_at               :datetime
#  edit_mode                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  error_message             :text
#  user_encoding             :string
#  default_library_id        :bigint
#  default_event_category_id :bigint
#
