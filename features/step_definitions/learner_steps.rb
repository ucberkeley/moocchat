Given /^a new learner named "(.*?)"$/ do |name|
  @learner = create(:learner, :name => name)
end
