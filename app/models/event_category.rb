class EventCategory < ActiveRecord::Base
  attr_accessible :name, :display_name, :note, :checkin_ng, :move_checkin_date 
  include MasterModel
  default_scope :order => "position"
  has_many :events

  paginates_per 10
end

# == Schema Information
#
# Table name: event_categories
#
#  id           :integer         not null, primary key
#  name         :string(255)     not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#

