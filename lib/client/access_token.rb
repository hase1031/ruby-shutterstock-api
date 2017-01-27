module ShutterstockAPI
  class AccessToken

    attr_accessor :token

    attr_accessor :expires_at

    attr_accessor :token_type

    def initialize(response)
      self.token = response['access_token']
      self.expires_at = Time.now + response['expires_in']
      self.token_type = response['token_type']
    end

    def expired?
      self.expires_at < Time.now
    end

  end
end
