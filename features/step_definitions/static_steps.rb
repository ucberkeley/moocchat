Given(/^I start on the Static Page$/) do 
	visit root_path
end

Then(/^I should see a JS dialog saying "(.*?)"$/) do |statement|
   var = page.driver.browser.switch_to.alert.text
   var == statement 
   page.driver.browser.switch_to.alert.accept
end


