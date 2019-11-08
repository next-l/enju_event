class EventImportFileTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition


  belongs_to :event_import_file, inverse_of: :event_import_file_transitions
end

