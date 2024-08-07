require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  # Configuração para autenticar o usuário nos testes
  config.before(:each) do
    if defined?(Warden)
      Warden.test_mode!
    end
  end

  config.after(:each) do
    if defined?(Warden)
      Warden.test_reset!
    end
  end

  # Configs Webmock
  config.before(:suite) do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.before(:each) do
    WebMock.reset!
  end

  config.use_transactional_fixtures = true

  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
end
