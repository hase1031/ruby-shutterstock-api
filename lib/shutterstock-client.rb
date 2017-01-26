require 'httparty'
require 'active_support/all'
require 'singleton'

module ShutterstockAPI
  require_relative './client/driver'
  require_relative './client/access_token'
  require_relative './client/configuration'
  require_relative './client/images'
  require_relative './client/image'

	class Client
		include HTTParty
		include Singleton

		# @return [Configuration] Config instance
		attr_reader :config

		# Request options
		attr_accessor :options

		# Creates a new {Client} instance and yields {#config}.
		# Requires a block to be given.
		def configure
			raise ArgumentError, "block not given" unless block_given?

			@config = Configuration.new
			yield config

			@config.api_url ||= "https://api.shutterstock.com/v2"
			raise ArgumentError, "Client ID not provided" if config.client_id.nil?
			raise ArgumentError, "Client secret not provided" if config.client_secret.nil?
      @config.default_scopes ||= []

			@options = {
				base_uri: config.api_url,
				oauth: {
          client_id: config.client_id,
          client_secret: config.client_secret,
				}
			}

      if config.access_token.nil?
        get_access_token
      end

			@options.delete_if{|k, v| k == :body}

			@options.merge!({
				headers: {
					'Authorization' => bearer_token(config.access_token.token),
				  'User-Agent' => 'Ruby Shutterstock API Client',
				}
			})
		end

		def configured?
			! config.nil?
		end

		def get_access_token(scopes=[])
			options=@options
      scopes = config.default_scopes if scopes.empty?
			options[:body] = { client_id: config.client_id, client_secret: config.client_secret, grant_type: 'client_credentials'}
      options[:body][:scope] = scopes.join(' ') unless scopes.empty?
			response = self.class.post( "#{config.api_url}/oauth/access_token", options )

			if response.code == 200
				config.access_token = ShutterstockAPI::AccessToken.new(response)
			else
				raise RuntimeError, "Something went wrong: #{response.code} #{response.message}"
			end
			config.access_token
		end

		def token_expired?
			config.access_token.expired?
    end

    def refresh_access_token
      access_token = get_access_token
      @options[:headers]['Authorization'] = bearer_token(access_token.token)
    end

		def method_missing(method, *args, &block)
			method = method.to_s
			options = args.last.is_a?(Hash) ? args.pop : {}

			klass = self.class.modulize_string(method.singularize)

			if ShutterstockAPI.const_defined?(klass)
				klass_as_const = ShutterstockAPI.const_get(klass)
				klass_as_const.new(options)
			else
				super
			end
		end

		# From https://github.com/rubyworks/facets/blob/master/lib/core/facets/string/modulize.rb
		def self.modulize_string(string)
			#gsub('__','/').  # why was this ever here?
			string.gsub(/__(.?)/){ "::#{$1.upcase}" }.
				gsub(/\/(.?)/){ "::#{$1.upcase}" }.
				gsub(/(?:_+|-+)([a-z])/){ $1.upcase }.
				gsub(/(\A|\s)([a-z])/){ $1 + $2.upcase }
		end

		# From https://github.com/rubyworks/facets/blob/master/lib/core/facets/string/snakecase.rb
		def self.snakecase_string(string)
			#gsub(/::/, '/').
			string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
				gsub(/([a-z\d])([A-Z])/,'\1_\2').
				tr('-', '_').
				gsub(/\s/, '_').
				gsub(/__+/, '_').
				downcase
    end

    private

    def bearer_token(token)
      "Bearer #{token}"
    end
	end
end
