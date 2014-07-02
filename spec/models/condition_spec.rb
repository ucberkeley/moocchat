require 'spec_helper'

describe Condition do
  it 'should have minimum group size <= preferred' do
    Condition.new(:name => 'x', :preferred_group_size => 2, :minimum_group_size => 3).
      should_not be_valid
  end
  it 'allows fixed group size' do
    Condition.new(:name => 'x',:prologue_pages => [create(:template)], :preferred_group_size => 2, :minimum_group_size => 2).
      should be_valid
  end
  it 'disallows huge groups' do
    Condition.new(:name => 'x', :preferred_group_size => 100, :minimum_group_size => 3).
      should_not be_valid
  end
  it 'allows singletons' do
    Condition.new(:name => 'x',:prologue_pages => [create(:template)], :preferred_group_size => 1, :minimum_group_size => 1).
      should be_valid
  end
  it 'requires a name' do
    Condition.new(:preferred_group_size => 1, :minimum_group_size => 1).should_not be_valid
  end
end
  