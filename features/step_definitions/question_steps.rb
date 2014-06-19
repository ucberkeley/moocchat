Given(/^I am on the Questions Page$/) do 
	visit question_path
end

Then(/^I should see a JS dialog saying "(.*?)"$/) do |statement|
   var = page.driver.browser.switch_to.alert.text
   var == statement 
   page.driver.browser.switch_to.alert.accept
end