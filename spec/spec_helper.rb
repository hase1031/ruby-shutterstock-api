require 'webmock'
require 'vcr'
require 'rspec'

require 'shutterstock-client'
include ShutterstockAPI

DEFAULTS = {
  SSTK_CLIENT_ID: 'clientid',
  SSTK_CLIENT_SECRET: 'clientsecret',
  SSTK_BASE_API_URI: 'http://api.shutterstock.com',
  SSTK_ACCESS_TOKEN: 'accesstoken',
}

def sensitive_data(c, env_key)
  c.filter_sensitive_data("<#{env_key}>") do
    ENV[env_key.to_s] || DEFAULTS[env_key]
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
  sensitive_data(c, :SSTK_CLIENT_ID)
  sensitive_data(c, :SSTK_CLIENT_SECRET)
end

if ENV['VCR_OFF']
  WebMock.allow_net_connect!
  VCR.turn_off!(ignore_cassettes: true)
end

uri_without_auth_token = VCR.request_matchers.uri_without_param(:auth_token)

RSpec.configure do |config|
  # Add VCR to all tests
  config.around(:each) do |example|
    options = example.metadata[:vcr] || {}
    options[:match_requests_on] = [:method, uri_without_auth_token]
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description]
        .split(/\s+/, 2).join('/')
        .gsub(/[^\w\/]+/, '_')
      VCR.use_cassette(name, options, &example)
    end
  end
end

def client
	Client.instance.configure do |config|
		config.client_id = ENV['SSTK_CLIENT_ID'] || "clientid"
		config.client_secret = ENV['SSTK_CLIENT_SECRET'] || "clientsecret"
    config.default_scopes = ['user.view', 'licenses.view']
	end
	Client.instance
end

def client_double
  double(
    client_id: client_id,
    client_secret: client_secret,
    api_url: base_api_uri,
    access_token: access_token,
    options: auth_options
  )
end

def mocked_auth
  Client.any_instance.stub(:get_access_token)
  client
  client.stub(:auth_token).and_return(auth_token)
  client.stub(:options).and_return(auth_options)
end

private

def auth_options(opts = {})
  {
    base_uri: base_api_uri,
    oauth: {
      client_id: client_id,
      client_secret: client_secret
    },
    default_params: {
      access_token: access_token
    }
  }.merge(opts)
end

def env_or_default(key)
  ENV[key.to_s] || DEFAULTS[key]
end

def client_id
  env_or_default(:SSTK_CLIENT_ID)
end

def client_secret
  env_or_default(:SSTK_CLIENT_SECRET)
end

def base_api_uri
  env_or_default(:SSTK_BASE_API_URI)
end

def access_token
  AccessToken.new({access_token: env_or_default(:SSTK_ACCESS_TOKEN), token_type: 'client_credentials', expires_in: 3600})
end
