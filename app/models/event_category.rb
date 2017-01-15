class EventCategory < ActiveRecord::Base
  include MasterModel
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
#  display_name_translations :jsonb
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
