require 'rails_helper'

describe "event_import_results/index.txt" do
  fixtures :all

  before(:each) do
    assign(:event_import_file_id, 1)
    assign(:event_import_results, EventImportFile.find(1).event_import_results)
  end

  it "renders a list of event_import_results" do
    render
    expect(CSV.parse(rendered, headers: true, col_sep: "\t").first['library']).to eq 'MyText'
  end
end
