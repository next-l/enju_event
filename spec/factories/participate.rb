FactoryBot.define do
  factory :participate do |f|
    f.event_id { FactoryBot.create(:event).id }
    f.agent_id { FactoryBot.create(:agent).id }
  end
end
