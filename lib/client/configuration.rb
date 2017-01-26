module ShutterstockAPI
	class Configuration
		# @return [AccessToken] The basic auth token.
		attr_accessor :access_token

		# @return [String] The API url.
		attr_accessor :api_url

    # @return [String] The client ID.
		attr_accessor :client_id

    # @return [String] The client secret.
    attr_accessor :client_secret

		# @return [Array] The default scope of API.
		attr_accessor :default_scopes

		def initialize
			@client_options = {}
		end

	end
end
