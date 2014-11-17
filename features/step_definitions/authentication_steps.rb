When /^I login successfully via Google as "(.*) (.*) <(.*)>"$/ do |first,last,email|
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      :provider => 'google_oauth2',
      :uid => '12345',
      :info => {
        :name => "#{first} #{last}",
        :email => email,
        :first_name => first,
        :last_name => last
      }
    })
  visit '/auth/google_oauth2'
end
