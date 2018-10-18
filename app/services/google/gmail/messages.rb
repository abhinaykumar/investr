module Google::Gmail
  class Messages < Google::Gmail::Base

    def initialize(user_id: nil, q: nil, access_token: nil)
      @access_token = access_token
      @user_id = user_id
      @q = q
    end

    def call
      service = Google::Gmail::Base.call @access_token
      messages = service.list_user_messages('me', q: "#{@q}", max_results: 10)
      transactions = []
      messages.messages.first(2).each do |message|
        content = service.get_user_message('me', message.id).payload
        transaction_date, source = parse_content(content.headers)
        html_receipt = content.body.data
        source = map_source[:"#{source}"]
        expense = public_send("parse_#{source}_html", html_receipt)
        transactions << { transaction_date: transaction_date, expense: expense, source: 'Swiggy' }
      end
      transactions
    end

    def parse_content(headers)
      t_date = headers.find { |x| x.name == "Date" }.value
      source = headers.find { |x| x.name == "From" }.value
      [t_date, source]
    end

    def parse_swiggy_html(html)
      parsed_html = Nokogiri::HTML(html)
      parsed_html.at_css('div.order-content table tfoot tr.grand-total td').text
    end

    def map_source
      {
        "noreply@swiggy.in": "swiggy"
      }
    end
  end
end
