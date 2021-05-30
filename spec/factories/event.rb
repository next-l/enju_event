FactoryBot.define do
  factory :event do
    sequence(:name){|n| "event_#{n}"}
    start_at{Time.zone.now}
    end_at{1.hour.from_now}
    library_id{FactoryBot.create(:library).id}
    event_category_id{FactoryBot.create(:event_category).id}
  end
end
