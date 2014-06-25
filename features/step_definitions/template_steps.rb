Given(/^a template "(.*?)"$/) do |arg1|
	@t1= Template.create!(name: "example1", html: "<h1>Default Template</h1>")
end

Given(/^I start on the Edit Page for template$/) do 
	visit edit_template_path(@t1)
end