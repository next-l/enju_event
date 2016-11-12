require 'spec_helper'

describe 'event_export_files/new' do
  before(:each) do
    assign(:event_export_file, stub_model(EventExportFile, user_id: 1).as_new_record)
    view.stub(:current_user).and_return(User.find(1))
  end

  it 'renders new event_export_file form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', event_export_files_path, 'post' do
    end
  end
end
