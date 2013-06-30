FactoryGirl.define do
  factory :participate do |f|
    f.event_id{FactoryGirl.create(:event).id}
    f.agent_id{FactoryGirl.create(:agent).id}
  end
end
