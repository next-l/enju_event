require 'rails_helper'

RSpec.describe 'EventCategorys', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When logged in as Administrator' do
    before do
      sign_in users(:admin)
    end

    it 'should show event_category config' do
      visit event_category_path(event_categories(:event_category_00002).id, locale: :ja)
      expect(page).to have_content '編集'
    end
  end

  describe 'When logged in as Librarian' do
    before do
      sign_in users(:librarian1)
    end

    it 'should not show event_category config' do
      visit event_category_path(event_categories(:event_category_00002).id, locale: :ja)
      expect(page).not_to have_content '編集'
    end
  end

  describe 'When logged in as User' do
    before do
      sign_in users(:user1)
    end

    it 'should not show event_category config' do
      visit event_category_path(event_categories(:event_category_00002).id, locale: :ja)
      expect(page).not_to have_content '編集'
    end
  end

  describe 'When not logged in' do
    it 'should not show event_category config' do
      visit event_category_path(event_categories(:event_category_00002).id, locale: :ja)
      expect(page).not_to have_content '編集'
    end
  end
end
