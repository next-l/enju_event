FactoryBot.define do
  factory :library do |f|
    f.sequence(:name){|n| "library#{n}"}
    f.sequence(:short_display_name){|n| "library_#{n}"}
    f.sequence(:display_name_en){|n| "library_#{n}"}
    f.sequence(:display_name_ja){|n| "library_#{n}"}
    f.library_group_id{LibraryGroup.first.id}
  end
end

FactoryBot.define do
  factory :invalid_library, class: Library do |f|
    f.library_group_id{LibraryGroup.first.id}
  end
end
