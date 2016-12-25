module ShutterstockAPI
	class Configuration
		# @return [String] The basic auth token.
		attr_accessor :access_token

		# @return [String] The API url.
		attr_accessor :api_url

    # @return [String] The client ID.
		attr_accessor :client_id

    # @return [String] The client secret.
    attr_accessor :client_secret

		def initialize
			@client_options = {}
		end

	end
end
