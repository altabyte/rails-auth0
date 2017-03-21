# Auth0 callbacks controller.
#
class Auth0Controller < ApplicationController
  include Auth0Helper

  before_action :set_session_userinfo, only: :callback

  # OmniAuth places the User Profile information (retrieved by omniauth-auth0) in request.env['omniauth.auth'].
  # In this tutorial, you will store that info in the session, under 'userinfo'.
  # If the id_token is needed, you can get it from session[:userinfo]['credentials']['id_token'].
  # Refer to https://github.com/auth0/omniauth-auth0#auth-hash for complete information on 'omniauth.auth' contents.
  def callback
    redirect_to dashboard_path, notice: "Logged in as #{session[:userinfo][:info][:email]}"
  end


  # If user authentication fails on the provider side OmniAuth will redirect to /auth/failure,
  # passing the error message in the 'message' request param.
  def failure
    @error_msg = request.params['message']
    puts @error_msg
  end

  #---------------------------------------------------------------------------
  private

  def set_session_userinfo
    session[:userinfo] = request.env['omniauth.auth']
    puts request.env['omniauth.auth'].to_yaml
  end
end