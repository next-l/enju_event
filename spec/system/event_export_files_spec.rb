require 'rails_helper'

RSpec.describe 'EventExportFiles', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When logged in as Administrator' do
    before do
      sign_in users(:admin)
    end

    it 'should get event_export_files index' do
      visit event_export_files_path
    end
  end
end
