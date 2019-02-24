FactoryBot.define do
  factory :event_export_file, class: EventExportFile do
    association :user
  end
end
