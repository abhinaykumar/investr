class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:google_oauth2]

  has_many :authorizations


  SOCIALS = {
    google_oauth2: 'Google'
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
end
