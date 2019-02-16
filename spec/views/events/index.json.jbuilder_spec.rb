require 'rails_helper'

describe "events/index.json.jbuilder" do
  fixtures :all

  before(:each) do
    20.times do |c|
      FactoryBot.create(:event)
    end
    assign(:events, Event.page(1))
  end

  it "renders a list of events" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(response.body).to match /\A\[/
    data = JSON.parse(response.body)
    expect(data.first).not_to be_nil
    expect(data.first).to have_key("start")
    expect(data.first).to have_key("url")
  end
end
