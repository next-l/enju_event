class EventCategory < ApplicationRecord
  include MasterModel
  default_scope { order('position') }
  has_many :events

  paginates_per 10
  translates :display_name
end

# == Schema Information
#
# Table name: event_categories
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
