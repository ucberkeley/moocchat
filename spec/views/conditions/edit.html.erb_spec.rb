require 'spec_helper'

describe "conditions/edit" do
  before(:each) do
    @condition = assign(:condition, stub_model(Condition))
  end

  it "renders the edit condition form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", condition_path(@condition), "post" do
    end
  end
end
