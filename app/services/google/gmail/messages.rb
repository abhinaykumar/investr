module Google::Gmail
  class Messages < Google::Gmail::Base

    def initialize(user_id: nil, q: nil, access_token: nil)
      @access_token = access_token
      @user_id = user_id
      @q = q
    end

    def call
      service = Google::Gmail::Base.call @access_token
      messages = service.list_user_messages('me', q: "from:noreply@swiggy.in")
      receipts = []
      messages.messages.first(10).each do |message|
        msg = service.get_user_message(user_id, message.id)
        receipts << msg.payload.body.data
      end
    end
  end
end
