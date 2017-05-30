# Auth0 callbacks controller.
#
class Auth0Controller < ApplicationController
  include Auth0Helper

  before_action :set_session, only: :callback

  layout 'public'

  # Helper method for RSpec tests to assign the session `state` variable used to prevent CSRF attacks.
  #
  #   `post auth_set_state_path, params: { state: SecureRandom.hex(24) }`
  #
  # Alternatively can set `provider_ignores_state: true` in config/initializers/auth0.rb
  # or set PROVIDER_IGNORES_STATE environmental variable to true.
  #
  def set_state
    session['omniauth.state'] = params[:state] if params.key?(:state) && Rails.env.test?
  end

  # OmniAuth places the User Profile information (retrieved by omniauth-auth0) in request.env['omniauth.auth'].
  # In this tutorial, you will store that info in the session, under 'userinfo'.
  # If the id_token is needed, you can get it from session[:userinfo]['credentials']['id_token'].
  # Refer to https://github.com/auth0/omniauth-auth0#auth-hash for complete information on 'omniauth.auth' contents.
  def callback
    redirect_to dashboard_path
  end

  # If user authentication fails on the provider side OmniAuth will redirect to /auth/failure,
  # passing the error message in the 'message' request param.
  def failure
    @error_msg = request.params['message']
    puts @error_msg
  end

  # Dedicated login page using Auth0 Lock.
  def login; end

  # Remember to register the *Allowed Logout URLs* at the following link.
  #
  # @see https://manage.auth0.com/#/account/advanced
  #
  def logout
    url = auth0_logout_url.to_s   # auth0_logout_url is defined in app/helpers/auth0_helper.rb
    return if url.blank?
    reset_session
    redirect_to url
  end

  #---------------------------------------------------------------------------
  private

  def set_session
    puts request.env['omniauth.auth'].to_yaml if Rails.env.development? || Rails.env.test?
    session[:id_token]   = request.env['omniauth.auth'].credentials.id_token
    session[:expires_at] = request.env['omniauth.auth'].credentials.expires_at
    session[:auth0_json] = request.env['omniauth.auth'].to_json
  end
end
