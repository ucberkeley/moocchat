require 'spec_helper'

describe "activity_schemas/show" do
  before(:each) do
    @activity_schema = assign(:activity_schema, stub_model(ActivitySchema))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
