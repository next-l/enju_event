require 'rails_helper'

RSpec.describe 'Places', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When logged in as Administrator' do
    before do
      sign_in users(:admin)
    end

    it 'should get places index' do
      visit places_path
    end
  end
end
