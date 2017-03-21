# ApplicationController
#
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :auth0_jwt

  def auth0_jwt
    session[:userinfo]&.fetch('credentials')&.fetch('id_token')
  end
end
