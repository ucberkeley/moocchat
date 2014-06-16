require 'spec_helper'

describe "activity_schemas/index" do
  before(:each) do
    assign(:activity_schemas, [
      stub_model(ActivitySchema),
      stub_model(ActivitySchema)
    ])
  end

  it "renders a list of activity_schemas" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
