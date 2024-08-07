class AuthenticationService
  include HTTParty

  def self.register(email, password, name)
    response = post("#{ENV['AUTH_SERVICE_URL']}/api/v1/register",
                    body: { email: email, password: password, name: name }.to_json,
                    headers: { 'Content-Type' => 'application/json' })

    if response.success?
      { success: true, message: 'User created successfully' }
    else
      errors = response.parsed_response['errors']
      { success: false, errors: errors }
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

    response =  post("#{ENV['AUTH_SERVICE_URL']}/api/v1/validate_token",
                     body: { token: token }.to_json,
                     headers: { 'Content-Type' => 'application/json' })

    if response.code == 200
      true
    else
      false
    end
  end

  def self.fetch_user_from_token(token)
    return nil if token.nil?

    response =  post("#{ENV['AUTH_SERVICE_URL']}/api/v1/validate_token",
                     body: { token: token }.to_json,
                     headers: { 'Content-Type' => 'application/json' })

    if response.code == 200
      user_data =  JSON.parse(response)

      User.create(id: user_data['id'], email: user_data['email'], name: user_data['name'])
    else
      nil
    end
  end
end
