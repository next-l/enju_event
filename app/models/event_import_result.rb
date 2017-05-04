class EventImportResult < ActiveRecord::Base
  default_scope { order('event_import_results.id') }
  scope :file_id, proc { |file_id| where(event_import_file_id: file_id) }
  scope :failed, -> { where(event_id: nil) }

  belongs_to :event_import_file
  belongs_to :event

  validates :event_import_file_id, presence: true
end

# == Schema Information
#
# Table name: event_import_results
#
#  id                   :integer          not null, primary key
#  event_import_file_id :integer
#  event_id             :integer
#  body                 :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
