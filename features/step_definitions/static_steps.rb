Given(/^I start on the Static Page$/) do 
	visit root_path
end

Then(/^I should see a JS dialog saying "(.*?)"$/) do |statement|
  #page.driver.browser.switch_to.alert.accept 
   var = page.driver.browser.switch_to.alert.text
   var == "please fill out all the form"
   page.driver.browser.switch_to.alert.accept
end




