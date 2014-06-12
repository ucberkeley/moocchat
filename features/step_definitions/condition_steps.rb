Given /^a condition "(.*?)"$/ do |name|
  build(:condition, :name => name)
end
