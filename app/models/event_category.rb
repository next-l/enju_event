class EventCategory < ActiveRecord::Base
  include MasterModel
  include Mobility
  default_scope { order('position') }
  has_many :events

  paginates_per 10
  translates :display_name
end

# == Schema Information
#
# Table name: event_categories
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  display_name :jsonb
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
