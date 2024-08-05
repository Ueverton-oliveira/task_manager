require 'httparty'

class AuthenticationService
  include HTTParty

  def initialize(email = nil, password = nil, token)
    @token = token
    @email = email
    @password = password
  end

  def self.register(email, password)
    response = post("#{ENV['AUTH_SERVICE_URL']}/api/v1/register",
                             body: { email: email, password: password }.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    if response.code == 201
      { success: true, message: response.parsed_response['message'] }
    else
      { success: false, errors: response.parsed_response['errors'] }
    end
  end

  def self.login(email, password)
    url = "#{ENV['AUTH_SERVICE_URL']}/api/v1/login"
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = { email: email, password: password }.to_json

    response = http.request(request)
    parsed_response = JSON.parse(response.body)

    if response.code == '200'
      { success: true, token: parsed_response['token'] }
    else
      { success: false, errors: ['Invalid credentials'] }
    end
  end

  def self.validate_token(token)
    return false if token.nil?

    response = post("#{ENV['AUTH_SERVICE_URL']}/api/v1/validate_token",
                             body: { token: token }.to_json,
                             headers: { 'Content-Type' => 'application/json' })

    if response.code == 200
      @user_id = response.parsed_response['user_id']
      true
    else
      false
    end
  end
end
