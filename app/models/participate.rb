class Participate < ActiveRecord::Base
  attr_accessible :patron_id, :event_id
  belongs_to :patron
  belongs_to :event

  validates_presence_of :patron_id, :event_id
  validates_uniqueness_of :patron_id, :scope => :event_id
  acts_as_list :scope => :event_id

  paginates_per 10
end

# == Schema Information
#
# Table name: participates
#
#  id         :integer         not null, primary key
#  patron_id  :integer         not null
#  event_id   :integer         not null
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

