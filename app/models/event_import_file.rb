class EventImportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include ImportFile
  include AttachmentUploader[:attachment]
  scope :not_imported, -> { in_state(:pending) }
  scope :stucked, -> { in_state(:pending).where('event_import_files.created_at < ?', 1.hour.ago) }

  validates :attachment, presence: true, on: :create
  belongs_to :user
  belongs_to :default_library, class_name: 'Library'
  belongs_to :default_event_category, class_name: 'EventCategory'
  has_many :event_import_results

  has_many :event_import_file_transitions

  before_create :set_fingerprint
  attr_accessor :mode

  def state_machine
    EventImportFileStateMachine.new(self, transition_class: EventImportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
           to: :state_machine

  def import
    transition_to!(:started)
    num = { imported: 0, failed: 0 }
    rows = open_import_file(create_import_temp_file(attachment.download))
    check_field(rows.first)
    row_num = 1

    rows.each do |row|
      row_num += 1
      next if row['dummy'].to_s.strip.present?
      event_import_result = EventImportResult.new
      event_import_result.assign_attributes(event_import_file_id: id, body: row.fields.join("\t"))
      event_import_result.save!

      event = Event.new
      event.name = row['name'].to_s.strip
      event.display_name = row['display_name']
      event.note = row['note']
      event.start_at = Time.zone.parse(row['start_at']) if row['start_at'].present?
      event.end_at = Time.zone.parse(row['end_at']) if row['end_at'].present?
      event.all_day = if %w(t true TRUE).include?(row['all_day'].to_s.strip)
                        true
                      else
                        false
                      end
      library = Library.find_by(name: row['library'])
      library = default_library || Library.web if library.blank?
      event.library = library
      event_category = EventCategory.find_by(name: row['event_category'])
      event_category = default_event_category if event_category.blank?
      event.event_category = event_category

      if event.save
        event_import_result.event = event
        num[:imported] += 1
        if (row_num % 50).zero?
          Sunspot.commit
          GC.start
        end
      else
        num[:failed] += 1
      end
      event_import_result.save!
    end
    Sunspot.commit
    rows.close
    transition_to!(:completed)
    send_message
    num
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    save
    transition_to!(:failed)
    raise e
  end

  def modify
    transition_to!(:started)
    rows = open_import_file(create_import_temp_file(attachment.download))
    check_field(rows.first)
    row_num = 1

    rows.each do |row|
      row_num += 1
      next if row['dummy'].to_s.strip.present?
      event = Event.find(row['id'].to_s.strip)
      event_category = EventCategory.find_by(name: row['event_category'].to_s.strip)
      event.event_category = event_category if event_category
      library = Library.find_by(name: row['library'].to_s.strip)
      event.library = library if library
      event.name = row['name'] if row['name'].to_s.strip.present?
      event.start_at = Time.zone.parse(row['start_at']) if row['start_at'].present?
      event.end_at = Time.zone.parse(row['end_at']) if row['end_at'].present?
      event.note = row['note'] if row['note'].to_s.strip.present?
      event.all_day = if %w(t true TRUE).include?(row['all_day'].to_s.strip)
                        true
                      else
                        false
                      end
      event.save!
    end
    transition_to!(:completed)
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    save
    transition_to!(:failed)
    raise e
  end

  def remove
    transition_to!(:started)
    rows = open_import_file(create_import_temp_file(attachment.download))
    rows.shift
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
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    save
    transition_to!(:failed)
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

  def open_import_file(tempfile)
    file = CSV.open(tempfile, col_sep: "\t")
    header_columns = %w(
      id name display_name library event_category start_at end_at all_day note dummy
    )
    header = file.first
    ignored_columns = header - header_columns
    unless ignored_columns.empty?
      self.error_message = I18n.t('import.following_column_were_ignored', column: ignored_columns.join(', '))
      save!
    end
    rows = CSV.open(tempfile, headers: header, col_sep: "\t")
    event_import_result = EventImportResult.new
    event_import_result.assign_attributes(event_import_file_id: id, body: header.join("\t"))
    event_import_result.save!
    tempfile.close(true)
    file.close
    rows
  end

  def check_field(field)
    if [field['name']].reject { |f| f.to_s.strip == '' }.empty?
      raise 'You should specify a name in the first line'
    end
    if [field['start_at'], field['end_at']].reject { |f| f.to_s.strip == '' }.empty?
      raise 'You should specify dates in the first line'
    end
  end

  def set_fingerprint
    self.event_import_fingerprint = Digest::SHA1.file(attachment.download.path).hexdigest
  end
end

# == Schema Information
#
# Table name: event_import_files
#
#  id                        :integer          not null, primary key
#  parent_id                 :integer
#  content_type              :string
#  size                      :integer
#  user_id                   :integer
#  note                      :text
#  executed_at               :datetime
#  event_import_filename     :string
#  event_import_content_type :string
#  event_import_size         :integer
#  event_import_updated_at   :datetime
#  edit_mode                 :string
#  created_at                :datetime
#  updated_at                :datetime
#  event_import_fingerprint  :string
#  error_message             :text
#  user_encoding             :string
#  default_library_id        :integer
#  default_event_category_id :integer
#  event_import_id           :string
#  attachment_data           :jsonb
#
