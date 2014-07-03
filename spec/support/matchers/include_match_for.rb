require 'rspec/expectations'

RSpec::Matchers.define :include_match_for do |regexp|
  match do |actual|
    actual.any? { |elt| elt.match(regexp) }
  end
end
