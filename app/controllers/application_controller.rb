require 'auth0/devise_methods'

# ApplicationController
#
class ApplicationController < ActionController::Base
  include Auth0::DeviseMethods if defined? Auth0
  include Auth0Helper if defined? Auth0
  include Pundit

  helper_method :user_signed_in?, :current_user, :auth0_claims, :auth0_id_token if defined? Auth0

  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?

  before_action :set_locale
  after_action  :session_timestamp!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    gon.locale = I18n.locale if defined? Gon
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || dashboard_path)
  end
end
