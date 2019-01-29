require 'rails_helper'

describe LibrariesController do
  fixtures :all

  describe 'GET show', solr: true do
    describe 'When logged in as Administrator' do
      login_fixture_admin

      it 'assigns the requested library as @library' do
        get :show, params: { id: libraries(:library_00001).id }
        assigns(:library).should eq(libraries(:library_00001))
      end
    end

    describe 'When logged in as Librarian' do
      login_fixture_librarian

      it 'assigns the requested library as @library' do
        get :show, params: { id: libraries(:library_00001).id }
        assigns(:library).should eq(libraries(:library_00001))
      end
    end

    describe 'When logged in as User' do
      login_fixture_user

      it 'assigns the requested library as @library' do
        get :show, params: { id: libraries(:library_00001).id }
        assigns(:library).should eq(libraries(:library_00001))
      end
    end

    describe 'When not logged in' do
      it 'assigns the requested library as @library' do
        get :show, params: { id: libraries(:library_00001).id }
        assigns(:library).should eq(libraries(:library_00001))
      end
    end
  end
end
