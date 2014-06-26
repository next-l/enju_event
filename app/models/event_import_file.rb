class EventImportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordModel
  include ImportFile
  default_scope {order('event_import_files.id DESC')}
  scope :not_imported, -> {in_state(:pending)}
  scope :stucked, -> {in_state(:pending).where('created_at < ?', 1.hour.ago)}

  if Setting.uploaded_file.storage == :s3
    has_attached_file :event_import, :storage => :s3,
      :s3_credentials => "#{Setting.amazon}",
      :s3_permissions => :private
  else
    has_attached_file :event_import,
      :path => ":rails_root/private/system/:class/:attachment/:id_partition/:style/:filename"
  end
  validates_attachment_content_type :event_import, :content_type => [
    'text/csv',
    'text/plain',
    'text/tab-separated-values',
    'application/octet-stream',
    'application/vnd.ms-excel'
  ]
  validates_attachment_presence :event_import
  #do_not_validate_attachment_file_type :event_import
  belongs_to :user, :validate => true
  has_many :event_import_results

  has_many :event_import_file_transitions

  def state_machine
    @state_machine ||= EventImportFileStateMachine.new(self, transition_class: EventImportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def import_start
    case edit_mode
    when 'create'
      import
    when 'update'
      modify
    when 'destroy'
      remove
    else
      import
    end
  end

  def import
    transition_to!(:started)
    num = {:imported => 0, :failed => 0}
    rows = open_import_file
    check_field(rows.first)
    row_num = 2

    rows.each do |row|
      next if row['dummy'].to_s.strip.present?
      event_import_result = EventImportResult.new
      event_import_result.assign_attributes({:event_import_file_id => id, :body => row.fields.join("\t")})
      event_import_result.save!

      event = Event.new
      event.name = row['name'].to_s.strip
      event.note = row['note']
      event.start_at = row['start_at']
      event.end_at = row['end_at']
      category = row['category'].to_s.strip
      if row['all_day'].to_s.strip.downcase == 'false'
        event.all_day = false
      else
        event.all_day = true
      end
      library = Library.where(:name => row['library']).first
      library = Library.web if library.blank?
      event.library = library
      event_category = EventCategory.where(:name => category).first || EventCategory.where(:name => 'unknown').first
      event.event_category = event_category

      if event.save!
        event_import_result.event = event
        num[:imported] += 1
      end
      event_import_result.save!
      row_num += 1
    end
    rows.close
    transition_to!(:completed)
    return num
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    transition_to!(:failed)
    raise e
  end

  def modify
    transition_to!(:started)
    rows = open_import_file
    check_field(rows.first)
    row_num = 2

    rows.each do |row|
      next if row['dummy'].to_s.strip.present?
      event = Event.find(row['id'].to_s.strip)
      event_category = EventCategory.where(:name => row['category'].to_s.strip).first
      event.event_category = event_category if event_category
      library = Library.where(:name => row['library'].to_s.strip).first
      event.library = library if library
      event.name = row['name'] if row['name'].to_s.strip.present?
      event.start_at = row['start_at'] if row['start_at'].to_s.strip.present?
      event.end_at = row['end_at'] if row['end_at'].to_s.strip.present?
      event.note = row['end_at'] if row['note'].to_s.strip.present?
      if row['all_day'].to_s.strip.downcase == 'false'
        event.all_day = false
      else
        event.all_day = true
      end
      event.save!
      row_num += 1
    end
    transition_to!(:completed)
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    transition_to!(:failed)
    raise e
  end

  def remove
    transition_to!(:started)
    rows = open_import_file
    rows.shift
    row_num = 2

    rows.each do |row|
      next if row['dummy'].to_s.strip.present?
      event = Event.find(row['id'].to_s.strip)
      event.picture_files.destroy_all # workaround
      event.reload
      event.destroy
      row_num += 1
    end
    transition_to!(:completed)
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    transition_to!(:failed)
    raise e
  end

  def self.import
    EventImportFile.not_imported.each do |file|
      file.import_start
    end
  rescue
    Rails.logger.info "#{Time.zone.now} importing events failed!"
  end

  private
  def self.transition_class
    EventImportFileTransition
  end

  def open_import_file
    tempfile = Tempfile.new('event_import_file')
    if Setting.uploaded_file.storage == :s3
      uploaded_file_path = event_import.expiring_url(10)
    else
      uploaded_file_path = event_import.path
    end
    open(uploaded_file_path){|f|
      f.each{|line|
        if defined?(CharlockHolmes::EncodingDetector)
          begin
            string = line.encode('UTF-8', CharlockHolmes::EncodingDetector.detect(line)[:encoding], universal_newline: true)
          rescue StandardError
            string = NKF.nkf('-w -Lu', line)
          end
        else
          string = NKF.nkf('-w -Lu', line)
        end
        tempfile.puts(string)
      }
    }
    tempfile.close

    file = CSV.open(tempfile, :col_sep => "\t")
    header = file.first
    rows = CSV.open(tempfile, :headers => header, :col_sep => "\t")
    event_import_result = EventImportResult.new
    event_import_result.assign_attributes({:event_import_file_id => id, :body => header.join("\t")})
    event_import_result.save!
    tempfile.close(true)
    file.close
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
#  id                        :integer          not null, primary key
#  parent_id                 :integer
#  content_type              :string(255)
#  size                      :integer
#  user_id                   :integer
#  note                      :text
#  executed_at               :datetime
#  state                     :string(255)
#  event_import_file_name    :string(255)
#  event_import_content_type :string(255)
#  event_import_file_size    :integer
#  event_import_updated_at   :datetime
#  edit_mode                 :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  event_import_fingerprint  :string(255)
#  error_message             :text
#
