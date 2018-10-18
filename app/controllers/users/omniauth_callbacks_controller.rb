# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    # Rails.logger.info("Auth hash" + "#{request.env['omniauth.auth']}")
    # Rails.logger.info("Auth hash" + "#{request.inspect}")
    # puts request.env['omniauth.auth']

    @user = User.from_omniauth(request.env['omniauth.auth'], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
      flash[:notice] = t('devise.omniauth_callbacks.success', kind: User::SOCIALS[params[:action].to_sym])
    else
      session['devise.user_data'] = @user.attributes
      redirect_to new_user_registration_url, notice: 'Please Sign-up'
    end
  end

  def zerodha
    # 1. https://kite.trade/connect/login?v=3&api_key=xxx
      # Navigate to the Kite Connect login page with the api_key
      # A succesful login comes back with a request_token to the registered redirect URL
      # POST the request_token and checksum (SHA-256 of api_key + request_token + api_secret) to /session/token
      # Obtain the access_token and use that with all subsequent requests

    # 2.Once the request_token is obtained from the login flow, it should be POSTed to
    # /session/token to complete the token exchange and retrieve the access_token.
      # curl https://api.kite.trade/session/token \
      #    -H "X-Kite-Version: 3" \
      #    -d "api_key=xxx" \
      #    -d "request_token=yyy" \
      #    -d "checksum=zzz"
    #
    # byebug
    #
    # @user = User.from_omniauth(request.env['omniauth.auth'], current_user)
    # if @user.persisted?
    #   sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
    #   set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    #   flash[:notice] = t('devise.omniauth_callbacks.success', kind: User::SOCIALS[params[:action].to_sym])
    # else
    #   session['devise.user_data'] = @user.attributes
    #   redirect_to new_user_registration_url, notice: 'Please Sign-up'
    # end
  end

  # User::SOCIALS.each do |k, _|
  #   alias_method k, :all
  # end

  def failure
    redirect_to new_user_registration_url, notice: 'something went wrong!'
  end
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
