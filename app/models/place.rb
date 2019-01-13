class Place < ActiveRecord::Base
  has_many :events
  validates :term, presence: true
end

# == Schema Information
#
# Table name: places
#
#  id         :bigint(8)        not null, primary key
#  term       :string
#  city       :text
#  country_id :bigint(8)
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
