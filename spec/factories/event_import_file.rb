FactoryBot.define do
  factory :event_import_file, class: EventImportFile do
    association :user
    association :default_library, factory: :library
    default_event_category_id { EventCategory.first.id }
  end
end
