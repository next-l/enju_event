require 'rails_helper'

RSpec.describe 'Events', type: :system do
  include Devise::Test::IntegrationHelpers
  fixtures :all

  describe 'When not logged in', solr: true do
    before(:each) do
      Event.reindex
    end

    it 'should contain query params in the facet' do
      visit events_path(query: 'test')
      expect(page).to have_link 'Kamata Library', href: events_path(library_id: 'kamata', query: 'test')
    end
  end
end
