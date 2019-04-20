class EventImportFileTransition < ActiveRecord::Base


  belongs_to :event_import_file, inverse_of: :event_import_file_transitions
  # attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: event_import_file_transitions
#
#  id                   :bigint(8)        not null, primary key
#  to_state             :string
#  metadata             :jsonb
#  sort_key             :integer
#  event_import_file_id :bigint(8)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  most_recent          :boolean          not null
#
