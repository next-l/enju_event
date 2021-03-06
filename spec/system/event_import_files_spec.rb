require 'rails_helper'

RSpec.describe 'EventImportFiles', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When logged in as Administrator' do
    before do
      sign_in users(:admin)
    end

    it 'should get event_import_files index' do
      visit event_import_files_path
    end
  end
end
