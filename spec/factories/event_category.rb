FactoryBot.define do
  factory :event_category do
    sequence(:name){|n| "event_category_#{n}"}
    sequence(:display_name_en){|n| "event_category_#{n}"}
    sequence(:display_name_ja){|n| "event_category_#{n}"}
  end
end
