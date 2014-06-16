require 'spec_helper'

describe "activity_schemas/edit" do
  before(:each) do
    @activity_schema = assign(:activity_schema, stub_model(ActivitySchema))
  end

  it "renders the edit activity_schema form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", activity_schema_path(@activity_schema), "post" do
    end
  end
end
