class EventCategory < ActiveRecord::Base
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
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer          default(1), not null
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
