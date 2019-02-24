FactoryBot.define do
  factory :event_import_result, class: EventImportResult do
    association :event_import_file
    association :event
  end
end
