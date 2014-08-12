require 'spec_helper'

describe "event_export_files/index" do
  fixtures :all

  before(:each) do
    assign(:event_export_files, Kaminari::paginate_array([
      stub_model(EventExportFile, user_id: 1),
      stub_model(EventExportFile, user_id: 1)
    ]).page(1))
  end

  it "renders a list of event_export_files" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
