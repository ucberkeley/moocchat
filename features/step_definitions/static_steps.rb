Given(/^I start on the Static Page$/) do 
	visit static_path
end

Then(/^I should see a JS dialog saying "(.*?)"$/) do |statement|
   #selenium solution
   #var = page.driver.browser.switch_to.alert.text 
   #var == statement 
   #page.driver.browser.switch_to.alert.accept

   #phantom solution
   page.execute_script("var page = this;" +
             "page.onConfirm = function(msg) {" +
                    "console.log('CONFIRM: ' + msg);"+
                    "return msg==statement;" +
             "};");
end

