require 'rails_helper'

describe EventExportFilesController do
  fixtures :all

  describe "GET index" do
    before do
      3.times do
        FactoryBot.create(:event_export_file)
      end
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns all event_export_files as @event_export_files" do
        get :index
        assigns(:event_export_files).should eq(EventExportFile.order('created_at DESC').page(1))
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns all event_export_files as @event_export_files" do
        get :index
        assigns(:event_export_files).should eq(EventExportFile.order('created_at DESC').page(1))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns empty as @event_export_files" do
        get :index
        assigns(:event_export_files).should be_nil
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns empty as @event_export_files" do
        get :index
        assigns(:event_export_files).should be_nil
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET show" do
    before do
      @event_export_file = FactoryBot.create(:event_export_file)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested event_export_file as @event_export_file" do
        get :show, params: { id: @event_export_file.id }
        assigns(:event_export_file).should eq(@event_export_file)
        response.should be_successful
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested event_export_file as @event_export_file" do
        get :show, params: { id: @event_export_file.id }
        assigns(:event_export_file).should eq(@event_export_file)
        response.should be_successful
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested event_export_file as @event_export_file" do
        get :show, params: { id: @event_export_file.id }
        assigns(:event_export_file).should eq(@event_export_file)
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns the requested event_export_file as @event_export_file" do
        get :show, params: { id: @event_export_file.id }
        assigns(:event_export_file).should eq(@event_export_file)
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested event_export_file as @event_export_file" do
        get :new
        assigns(:event_export_file).should be_valid
        response.should be_successful
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "should not assign the requested event_export_file as @event_export_file" do
        get :new
        assigns(:event_export_file).should be_valid
        response.should be_successful
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should not assign the requested event_export_file as @event_export_file" do
        get :new
        assigns(:event_export_file).should be_nil
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested event_export_file as @event_export_file" do
        get :new
        assigns(:event_export_file).should be_nil
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "should create agent_export_file" do
        post :create, params: { event_export_file: { event_export_file_name: 'test.txt' } }
        assigns(:event_export_file).should be_valid
        assigns(:event_export_file).user.username.should eq @user.username
        response.should redirect_to event_export_file_url(assigns(:event_export_file))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should be forbidden" do
        post :create, params: { event_export_file: { event_export_file_name: 'test.txt' } }
        assigns(:event_export_file).should be_nil
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should be redirected to new session url" do
        post :create, params: { event_export_file: { event_export_file_name: 'test.txt' } }
        assigns(:event_export_file).should be_nil
        response.should redirect_to new_user_session_url
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @event_export_file = FactoryBot.create(:event_export_file)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "destroys the requested event_export_file" do
        delete :destroy, params: { id: @event_export_file.id }
      end

      it "redirects to the event_export_files list" do
        delete :destroy, params: { id: @event_export_file.id }
        response.should redirect_to(event_export_files_url)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "destroys the requested event_export_file" do
        delete :destroy, params: { id: @event_export_file.id }
      end

      it "redirects to the event_export_files list" do
        delete :destroy, params: { id: @event_export_file.id }
        response.should redirect_to(event_export_files_url)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "destroys the requested event_export_file" do
        delete :destroy, params: { id: @event_export_file.id }
      end

      it "should be forbidden" do
        delete :destroy, params: { id: @event_export_file.id }
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested event_export_file" do
        delete :destroy, params: { id: @event_export_file.id }
      end

      it "should be forbidden" do
        delete :destroy, params: { id: @event_export_file.id }
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
