require 'rails_helper'

describe "event_export_files/show" do
  before(:each) do
    @event_export_file = assign(:event_export_file, stub_model(EventExportFile))
    view.stub(:current_user).and_return(User.find(1))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
