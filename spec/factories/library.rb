FactoryBot.define do
  factory :library do
    sequence(:name){|n| "library#{n}"}
    sequence(:display_name){|n| "library#{n}"}
    sequence(:short_display_name){|n| "library_#{n}"}
    library_group_id{LibraryGroup.first.id}
  end
end

FactoryBot.define do
  factory :invalid_library, class: Library do
    library_group_id{LibraryGroup.first.id}
  end
end
