class Role < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  def self.default_role
    Role.find('Guest')
  end
end
