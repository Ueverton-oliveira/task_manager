require 'rails_helper'
require 'webmock/rspec'

RSpec.describe AuthenticationService, type: :service do
  let(:auth_service_url) { ENV['AUTH_SERVICE_URL'] }
  let(:email) { 'test@example.com' }
  let(:password) { 'password123' }
  let(:token) { 'dummy_token' }
  let(:register_url) { "#{auth_service_url}/api/v1/register" }
  let(:login_url) { "#{auth_service_url}/api/v1/login" }
  let(:validate_token_url) { "#{auth_service_url}/api/v1/validate_token" }

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  describe '.register' do
    context 'when registration is successful' do
      it 'registers a user successfully' do
        stub_request(:post, "#{ENV['AUTH_SERVICE_URL']}/api/v1/register")
          .with(
            body: { email: 'test2@example.com', password: 'password', name: 'Test User' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(status: 201, body: { message: 'User created successfully' }.to_json, headers: {})

        result = AuthenticationService.register('test2@example.com', 'password', 'Test User')

        expect(result).to eq({ success: true, message: 'User created successfully' })
      end
    end

    context 'when registration fails' do
      it 'fails to register a user' do
        stub_request(:post, "#{ENV['AUTH_SERVICE_URL']}/api/v1/register")
          .with(
            body: { email: 'test@example.com', password: 'password', name: 'Test User' }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(status: 400, body: { errors: ['Email has already been taken'] }.to_json, headers: {})

        result = AuthenticationService.register('test@example.com', 'password', 'Test User')

        expect(result).to eq({ success: false, errors: ['Email has already been taken'] })
      end
    end
  end

  describe '.login' do
    it 'logs in successfully' do
      stub_request(:post, login_url)
        .with(
          body: { email: email, password: password }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(status: 200, body: { token: token }.to_json, headers: {})

      response = AuthenticationService.login(email, password)
      expect(response).to eq({ success: true, token: token })
    end

    it 'fails to log in with invalid credentials' do
      stub_request(:post, login_url)
        .with(
          body: { email: email, password: password }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(status: 401, body: { errors: ['Invalid credentials'] }.to_json, headers: {})

      response = AuthenticationService.login(email, password)
      expect(response).to eq({ success: false, errors: ['Invalid credentials'] })
    end
  end

  describe '.validate_token' do
    it 'validates a token successfully' do
      stub_request(:post, validate_token_url)
        .with(
          body: { token: token }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(status: 200, body: {}.to_json, headers: {})

      expect(AuthenticationService.validate_token(token)).to be true
    end

    it 'fails to validate a token' do
      stub_request(:post, validate_token_url)
        .with(
          body: { token: token }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(status: 401, body: { errors: ['Invalid token'] }.to_json, headers: {})

      expect(AuthenticationService.validate_token(token)).to be false
    end

    it 'returns false if no token is provided' do
      expect(AuthenticationService.validate_token(nil)).to be false
    end
  end

  describe '.fetch_user_from_token' do
    context 'when token is valid' do
      it 'fetches user successfully' do
        user_data = { id: 1, email: 'user@example.com', name: 'User' }

        stub_request(:post, validate_token_url)
          .with(
            body: { token: token }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(status: 200, body: user_data.to_json, headers: {})

        user = AuthenticationService.fetch_user_from_token(token)

        expect(user).to be_a(User)
        expect(user.id).to eq(1)
        expect(user.email).to eq('user@example.com')
        expect(user.name).to eq('User')
      end
    end

    context 'when token is invalid' do
      it 'returns nil' do
        stub_request(:post, validate_token_url)
          .with(
            body: { token: token }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(status: 401, body: { error: 'Unauthorized' }.to_json, headers: {})

        user = AuthenticationService.fetch_user_from_token(token)

        expect(user).to be_nil
      end
    end

    context 'when token is nil' do
      it 'returns nil' do
        user = AuthenticationService.fetch_user_from_token(nil)

        expect(user).to be_nil
      end
    end
  end
end
