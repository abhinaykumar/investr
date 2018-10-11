module Google::Gmail
  class Messages < Google::Gmail::Base

    def initialize(user_id: nil, q: nil, access_token: nil)
      @access_token = access_token
      @user_id = user_id
      @q = q
    end

    def call
      service = Google::Gmail::Base.call @access_token
      messages = service.list_user_messages('me', q: "from:noreply@swiggy.in", max_results: 10)
      transactions = []
      messages.messages.first(10).each do |message|
        content = service.get_user_message('me', message.id).payload
        transaction_date = content.headers.find { |x| x.name == "Date" }.value
        html_receipt = content.body.data
        expense = parse_html(html_receipt)
        transactions << { transaction_date: transaction_date, expense: expense, source: 'Swiggy' }
      end
      transactions
    end

    def parse_html(html)
      parsed_html = Nokogiri::HTML(html)
      parsed_html.at_css('div.order-content table tfoot tr.grand-total td').text
    end
  end
end
