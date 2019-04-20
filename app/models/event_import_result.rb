class EventImportResult < ActiveRecord::Base
  default_scope { order('event_import_results.id') }
  scope :file_id, proc{|file_id| where(event_import_file_id: file_id)}
  scope :failed, -> { where(event_id: nil) }

  belongs_to :event_import_file
  belongs_to :event, optional: true

  validates :event_import_file_id, presence: true
end

# == Schema Information
#
# Table name: event_import_results
#
#  id                   :bigint(8)        not null, primary key
#  event_import_file_id :bigint(8)
#  event_id             :bigint(8)
#  body                 :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
