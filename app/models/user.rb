class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:google_oauth2, :zerodha]

  has_many :authorizations


  SOCIALS = {
    google_oauth2: 'Google',
    zerodha: 'Zerodha'
  }

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first_or_initialize
    authorization.token = auth.credentials.token
    authorization.secret = auth.credentials.secret
    authorization.expires_at = auth.credentials.expires_at
    authorization.refresh_token = auth.credentials.refresh_token if auth.credentials.refresh_token

    if authorization.user.blank?
      user = current_user.nil? ? User.find_by(email: auth['info']['email']) : current_user
      if user.blank?
        user = User.new
        user.password = Devise.friendly_token[0, 20]
        user.email = auth.info.email
        user.name = auth.info.name
        user.skip_confirmation!
        user.save!
      end
      authorization.user = user
    end
    authorization.save && authorization.user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.user_data"]
        user.email = data['email'] if user.email.blank?
        user.valid?
      end
    end
  end

  # Email is required to signin from social media
  def email_required?
    true
  end

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    update_attribute(:deleted_at, Time.current)
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  def ten_financial_transaction
    renew_token if token_expired?
    Google::Gmail::Messages.call user_id: 'me', q: "#{build_query_from_sources}", access_token: google_auth.token
  end

  def build_query_from_sources
    query = ''
    sources = Source.all.as_json(only: [:email, :subject])
    sources.each do |source|
      query_f = "{from:#{source['email']}"
      query_s = source['subject'].present? ? "#{query_f} AND subject:#{source['subject']}}" : "#{query_f}}"
      query_s += " OR " unless source['email'] == sources.last['email']
      query += query_s
    end
    query
  end


  private
    def google_auth
      self.authorizations.where(provider: 'google_oauth2').first
    end

    def renew_token
      token = Google::RefreshToken.call google_auth.refresh_token
      expires_at = Time.now.to_i + Time.at(token['expires_in']).utc.strftime("%H:%M:%S").to_i
      google_auth.update! token: token['access_token'], expires_at: expires_at
    end

    def token_expired?
      expires_at = Time.at(google_auth.expires_at.to_i).strftime('%d %m %Y %H:%M')
      current_time = Time.now.strftime('%d %m %Y %H:%M')
      expires_at < current_time
    end
end
