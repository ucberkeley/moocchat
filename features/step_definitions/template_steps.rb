Given(/^a pregenerated Template named "(.*?)"$/) do |name|
  @template = create(:template, :name => name, 
  	:html => "<h2>hello there</h2>")
end

Given(/^I start on the Edit Page for template$/) do
	visit edit_template_path(@template)
end

Then(/^I should redirect to the show page for "(.*?)"$/) do |template|
	current_path.should == template_path(@template)
end
