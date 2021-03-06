FactoryBot.define do
  factory :event do |f|
    f.sequence(:name){|n| "event_#{n}"}
    f.start_at{Time.zone.now}
    f.end_at{1.hour.from_now}
    f.library_id{FactoryBot.create(:library).id}
    f.event_category_id{FactoryBot.create(:event_category).id}
  end
end
