class EventImportFileTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :event_import_file, inverse_of: :event_import_file_transitions
  attr_accessible :to_state, :sort_key, :metadata
end
