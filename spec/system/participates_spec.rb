require 'rails_helper'

RSpec.describe 'Participates', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When logged in as Administrator' do
    before do
      sign_in users(:admin)
    end

    it 'should get participates index' do
      visit participates_path
    end
  end
end
