# spec/support/authentication_helper.rb
module AuthenticationHelper
  def stub_authentication_service
    allow(AuthenticationService).to receive(:login).and_return({ success: true, token: 'mock_token' })
    allow(AuthenticationService).to receive(:validate_token).and_return(true)
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :controller
end
