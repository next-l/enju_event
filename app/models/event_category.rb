class EventCategory < ActiveRecord::Base
  include MasterModel
  default_scope { order('position') }
  has_many :events

  paginates_per 10
end

# == Schema Information
#
# Table name: event_categories
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
