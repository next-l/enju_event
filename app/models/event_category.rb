class EventCategory < ActiveRecord::Base
  include MasterModel
  default_scope lambda{order('event_categories.position')}
  has_many :events

  paginates_per 10
end

# == Schema Information
#
# Table name: event_categories
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#
