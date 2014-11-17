Given /^a new learner named "(.*?)"$/ do |name|
  @learner = create(:learner, :name => name)
end
Given /^an? (Learner|Instructor|Administrator) "(.*)" with Google email "(.*)"$/ do |role,name,email|
  role = role.downcase
  self.instance_variable_set("@#{role}", create(role, :name => name, :email => email))
end
