class HomesController < ApplicationController
  def index
    client = Signet::OAuth2::Client.new(access_token: current_user.authorizations.last.token)

    service = Google::Apis::GmailV1::GmailService.new

    service.authorization = client

    @labels_list = service.list_user_labels('me')
  end
end

# STEPS:
## https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/GmailV1/GmailService#get_user_message-instance_method
# Refresh token
# data = {
#           client_id: '668430063482-ju2oee5np09ul795gupctbkq2hkgh6tc.apps.googleusercontent.com',
#           client_secret: 'jnqdUqXMWx1HrSZ0UJOGgzMW',
#           refresh_token: "1/I_axJ-Sofg-fpRqNS_Pfpfy4Dhe46cBwQ5H8qiGaKok",
#           grant_type: 'refresh_token'
#         }
#         token = JSON.parse(RestClient.post 'https://accounts.google.com/o/oauth2/token', data)
#         access_token = token['access_token']
# client = Signet::OAuth2::Client.new(access_token: current_user.authorizations.last.token)
#
# service = Google::Apis::GmailV1::GmailService.new
#
# service.authorization = client

# a = service.list_user_messages('me', q: "from:noreply@swiggy.com")

# a.messages => returns array of message id

# a.messages.first.id => 163d10b4665f0720

# msg = service.get_user_message('me', msg_id)
#
# ex: msg = service.get_user_message('me', '163bff5c053efe64')
