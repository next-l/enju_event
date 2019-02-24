require 'rails_helper'

describe "event_export_files/index" do
  fixtures :all

  before(:each) do
    2.times do
      FactoryBot.create(:event_export_file)
    end
    assign(:event_export_files, EventExportFile.page(1))
  end

  it "renders a list of event_export_files" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
