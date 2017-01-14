FactoryGirl.define do
  factory :profile, class: Profile do |f|
    f.user_group_id { UserGroup.first.id }
    f.required_role_id { Role.where(name: 'User').first.id }
    f.sequence(:user_number) { |n| "user_number_#{n}" }
    f.library { Library.find_by(name: 'kamata') }
    f.locale 'ja'
    f.user_id { FactoryGirl.create(:user).id }
  end
end
