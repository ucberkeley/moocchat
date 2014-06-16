require 'spec_helper'

describe "conditions/index" do
  before(:each) do
    assign(:conditions, [
      stub_model(Condition),
      stub_model(Condition)
    ])
  end

  it "renders a list of conditions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
