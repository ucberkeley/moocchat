require 'spec_helper'

describe "activity_schemas/new" do
  before(:each) do
    assign(:activity_schema, stub_model(ActivitySchema).as_new_record)
  end

  it "renders new activity_schema form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", activity_schemas_path, "post" do
    end
  end
end
