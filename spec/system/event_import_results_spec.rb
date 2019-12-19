require 'rails_helper'

RSpec.describe 'EventImportResults', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When logged in as Administrator' do
    before do
      sign_in users(:admin)
    end

    it 'should get event_import_results index' do
      visit event_import_results_path
      expect(page).to have_link 'TSV'
    end
  end
end
