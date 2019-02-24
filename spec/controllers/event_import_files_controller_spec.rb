require 'rails_helper'

describe EventImportFilesController do
  fixtures :all

  describe "GET index" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns all event_import_files as @event_import_files" do
        get :index
        assigns(:event_import_files).should eq(EventImportFile.order(created_at: :desc).page(1))
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns all event_import_files as @event_import_files" do
        get :index
        assigns(:event_import_files).should eq(EventImportFile.order(created_at: :desc).page(1))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns empty as @event_import_files" do
        get :index
        assigns(:event_import_files).should be_nil
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns empty as @event_import_files" do
        get :index
        assigns(:event_import_files).should be_nil
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET show" do
    before do
      @event_import_file = FactoryBot.create(:event_import_file)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested event_import_file as @event_import_file" do
        get :show, params: { id: @event_import_file.id }
        assigns(:event_import_file).should eq(@event_import_file)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested event_import_file as @event_import_file" do
        get :show, params: { id: @event_import_file.id }
        assigns(:event_import_file).should eq(@event_import_file)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested event_import_file as @event_import_file" do
        get :show, params: { id: @event_import_file.id }
        assigns(:event_import_file).should eq(@event_import_file)
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns the requested event_import_file as @event_import_file" do
        get :show, params: { id: @event_import_file.id }
        assigns(:event_import_file).should eq(@event_import_file)
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested event_import_file as @event_import_file" do
        get :new
        assigns(:event_import_file).should_not be_valid
        response.should be_successful
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "should not assign the requested event_import_file as @event_import_file" do
        get :new
        assigns(:event_import_file).should_not be_valid
        response.should be_successful
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should not assign the requested event_import_file as @event_import_file" do
        get :new
        assigns(:event_import_file).should be_nil
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested event_import_file as @event_import_file" do
        get :new
        assigns(:event_import_file).should be_nil
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "should create event_import_file" do
        post :create, params: { event_import_file: {event_import: fixture_file_upload("/../../examples/event_import_file_sample1.tsv", 'text/csv') } }
        assigns(:event_import_file).should be_valid
        assigns(:event_import_file).user.username.should eq @user.username
        response.should redirect_to event_import_file_url(assigns(:event_import_file))
      end

      it "should import user" do
        old_events_count = Event.count
        post :create, params: { event_import_file: {event_import: fixture_file_upload("/../../examples/event_import_file_sample2.tsv", 'text/csv'), default_library_id: libraries(:library_00003).id, default_event_category_id: 3 } }
        assigns(:event_import_file).import_start
        Event.count.should eq old_events_count + 2
        response.should redirect_to event_import_file_url(assigns(:event_import_file))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should be forbidden" do
        post :create, params: { event_import_file: {event_import: fixture_file_upload("/../..//examples/event_import_file_sample1.tsv", 'text/csv') } }
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should be redirect to new session url" do
        post :create, params: { event_import_file: {event_import: fixture_file_upload("/../../examples/event_import_file_sample1.tsv", 'text/csv') } }
        response.should redirect_to new_user_session_url
      end
    end
  end

  describe "GET edit" do
    before do
      @event_import_file = FactoryBot.create(:event_import_file)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "assigns the requested event_import_file as @event_import_file" do
        get :edit, params: { id: @event_import_file.id }
        assigns(:event_import_file).should eq(@event_import_file)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "assigns the requested event_import_file as @event_import_file" do
        get :edit, params: { id: @event_import_file.id }
        assigns(:event_import_file).should eq(@event_import_file)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "assigns the requested event_import_file as @event_import_file" do
        get :edit, params: { id: @event_import_file.id }
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested event_import_file as @event_import_file" do
        get :edit, params: { id: @event_import_file.id }
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "PUT update" do
    before do
      @event_import_file = FactoryBot.create(:event_import_file)
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "should update event_import_file" do
        put :update, params: { id: @event_import_file.id, event_import_file: { edit_mode: 'update' } }
        response.should redirect_to event_import_file_url(assigns(:event_import_file))
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "should not update event_import_file" do
        put :update, params: { id: @event_import_file.id, event_import_file: { } }
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not update event_import_file" do
        put :update, params: { id: @event_import_file.id, event_import_file: { } }
        response.should redirect_to new_user_session_url
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @event_import_file = FactoryBot.create(:event_import_file)
    end

    describe "When logged in as Administrator" do
      login_fixture_admin

      it "destroys the requested event_import_file" do
        delete :destroy, params: { id: @event_import_file.id }
      end

      it "redirects to the event_import_files list" do
        delete :destroy, params: { id: @event_import_file.id }
        response.should redirect_to(event_import_files_url)
      end
    end

    describe "When logged in as Librarian" do
      login_fixture_librarian

      it "destroys the requested event_import_file" do
        delete :destroy, params: { id: @event_import_file.id }
      end

      it "redirects to the event_import_files list" do
        delete :destroy, params: { id: @event_import_file.id }
        response.should redirect_to(event_import_files_url)
      end
    end

    describe "When logged in as User" do
      login_fixture_user

      it "destroys the requested event_import_file" do
        delete :destroy, params: { id: @event_import_file.id }
      end

      it "should be forbidden" do
        delete :destroy, params: { id: @event_import_file.id }
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested event_import_file" do
        delete :destroy, params: { id: @event_import_file.id }
      end

      it "should be forbidden" do
        delete :destroy, params: { id: @event_import_file.id }
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
