# ApplicationController
#
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

  after_action  :session_timestamp!

  helper_method :auth0_jwt

  #---------------------------------------------------------------------------
  private

  def ssl_configured?
    ENV.fetch('FORCE_SSL', false).to_s.downcase.in? %w[1 true yes]
  end

  # Capture timestamp after each action, so can later cleanup stale sessions.
  #
  def session_timestamp!
    session['updated_at'] = Time.now.utc.to_i
  end

  def auth0_jwt
    session[:userinfo]&.fetch('credentials')&.fetch('id_token')
  end
end
