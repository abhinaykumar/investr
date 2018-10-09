module Google
  class Base < Service
    #add common utilities here
    def initialize(*args)
      #add default intance
    end

    def self.initialize_client(access_token)
      Signet::OAuth2::Client.new(access_token: access_token)
    end
  end
end
