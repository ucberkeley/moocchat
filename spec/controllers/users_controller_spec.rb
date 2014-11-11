require 'spec_helper'

def record_and_check(val, username, expected)
  get :record_consent, {:username => username, :consent => val }
  get :check_consent, {:username => username, :callback => 'jsonCallback' }
  regex = /^jsonCallback\((.*)\)$/
  response.body.should =~ regex
  response.body.match regex
  @response = JSON($1)
  @response['completed'].should be_true
  @response['consented'].should == expected
end

describe UsersController do

  describe 'record_consent' do
    before :each do
      @params = {:username => 'record_consent_test_user', :consent => 'true' }
    end
    context 'via AJAX GET' do
      it 'creates new user record' do
        expect { get :record_consent, @params }.to change { User.count }.by(1)
      end
    end
  end

  describe 'check_consent' do
    context 'nonexistent user' do
      it 'returns not completed for nonexistent user' do
        get :check_consent, {:username => 'nonexistent_user', :callback => 'jsonCallbackNonexistentUser' }
        regex = /^jsonCallbackNonexistentUser\((.*)\)$/
        response.body.should =~ regex
        response.body.match regex
        @response = JSON($1)
        @response['completed'].should be_false
      end
    end
    context 'consenting user' do
      it 'returns completed and consented for consenting user (true)' do
        record_and_check('true', 'user_true', true)
      end
      it 'returns completed and consented for consenting user (1)' do
        record_and_check('1', 'user_1', true)
      end
    end
    context 'rejecting user' do
      it 'returns completed and not consented for rejecting user (false)' do
        record_and_check('false', 'user_false', false)
      end
      it 'returns completed and not consented for rejecting user (0)' do
        record_and_check('0', 'user_0', false)
      end
    end
    context 'repeat user' do
      before :each do
        post :record_consent, {:username => 'user_repeat', :consent => 'false' }
      end
      it 'updates consent state each time if user sends multiple requests' do
        record_and_check('true', 'user_repeat', true)
      end
    end
    context 'check timestamp' do
      it 'records a correct timestamp' do
        @start_time = Time.current.utc
        post :record_consent, {:username => 'user_check_timestamp', :consent => '1' }
        @end_time = Time.current.utc
        @user = User.find_by_name('user_check_timestamp')
        @time = @user.consent_timestamp
        @time.should be >= @start_time
        @time.should be <= @end_time
      end
    end
  end

end
