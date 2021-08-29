class EventCategory < ApplicationRecord
  include MasterModel
  default_scope { order('position') }
  has_many :events

  translates :display_name
  paginates_per 10
end

# == Schema Information
#
# Table name: event_categories
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
