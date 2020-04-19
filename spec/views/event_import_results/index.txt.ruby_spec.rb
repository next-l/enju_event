require 'rails_helper'

describe "event_import_results/index.txt.ruby" do
  fixtures :all

  before(:each) do
    file = EventImportFile.create!(
      default_library_id: 3,
      default_event_category: EventCategory.find(3),
      user: users(:admin)
    )
    file.event_import.attach(io: File.new("#{Rails.root.to_s}/../../examples/event_import_file_sample1.tsv"), filename: 'attachment.txt')
    file.import_start
    assign(:event_import_file_id, file.id)
    assign(:event_import_results, EventImportFile.find(file.id).event_import_results)
  end

  it "renders a list of event_import_results" do
    render
    expect(CSV.parse(rendered, headers: true, col_sep: "\t").first['library']).to eq 'hachioji'
  end
end
