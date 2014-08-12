require 'spec_helper'

describe "event_export_files/edit" do
  before(:each) do
    @event_export_file = assign(:event_export_file, stub_model(EventExportFile, user_id: 1))
    view.stub(:current_user).and_return(User.find(1))
  end

  it "renders the edit event_export_file form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", event_export_file_path(@event_export_file), "post" do
    end
  end
end
