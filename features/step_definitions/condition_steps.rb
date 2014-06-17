Given /^a condition "(.*?)"$/ do |name|
  create :condition, :name => name
end
