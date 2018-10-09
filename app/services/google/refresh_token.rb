module Google
  class RefreshToken < Google::Base

    def initialize(refresh_token)
      @refresh_token = refresh_token
    end

    def call
      begin
        data = {
                  client_id: Rails.application.credentials.google[:client_id],
                  client_secret: Rails.application.credentials.google[:client_secret],
                  refresh_token: @refresh_token,
                  grant_type: 'refresh_token'
                }
        token = JSON.parse(RestClient.post 'https://accounts.google.com/o/oauth2/token', data)
      rescue StandardError
        false
      end
    end
  end
end
