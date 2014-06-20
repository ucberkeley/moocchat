require 'spec_helper'

describe ActivitySchema do
  it 'end time must be later than start time' do
    ActivitySchema.new(:name => 'x', :starts_every => 10,
      :start_time => 1.minute.from_now, :end_time => 1.minute.ago). should_not be_valid
    ActivitySchema.new(:name => 'x', :starts_every => 10,
      :end_time => 1.minute.from_now, :start_time => 1.minute.ago).should be_valid
  end
      

end
