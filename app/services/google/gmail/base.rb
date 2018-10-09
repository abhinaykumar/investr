module Google::Gmail
  class Base < Google::Base
    def initialize(access_token)
      @access_token = access_token
    end

    def call
      begin
        client = Google::Base.initialize_client @access_token
        service = Google::Apis::GmailV1::GmailService.new
        service.authorization = client
        service
      rescue StandardError => e
        puts e.message
        false
      end
    end
  end
end
