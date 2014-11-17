require 'spec_helper'

describe User do
  describe 'authentication' do
    before :each do
      @instructor = create :instructor
      @administrator = create :administrator
      @learner = create :learner
    end
    specify 'for administrators and instructors' do
      expect(@instructor).to be_authorized
      expect(@administrator).to be_authorized
    end
    specify 'for learners' do
      expect(@learner).not_to be_authorized
    end
    specify 'for legit id' do
      expect(User.authorized?(@instructor.id)).to be_true
      expect(User.authorized?(@administrator.id)).to be_true
      expect(User.authorized?(@learner.id)).to be_false
    end
    specify 'for bogus id' do
      expect(User.authorized?(999999)).to be_false
    end
    specify 'for nil id' do
      expect(User.authorized?(nil)).to be_false
    end
  end
end

  
