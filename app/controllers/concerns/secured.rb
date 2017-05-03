# Secured should be included in all controllers that must be password protected.
#
module Secured

  extend ActiveSupport::Concern

  included do
    include Pundit
    before_action :logged_in_using_omniauth?
  end

  #---------------------------------------------------------------------------
  private

  def logged_in_using_omniauth?
    if session[:userinfo].present?
      begin
        JWT.decode(auth0_id_token, nil, false)
      rescue JWT::ExpiredSignature
        session.delete(:userinfo)
        redirect_to(login_path, alert: 'Session expired')
      end
    else
      redirect_to(login_path, alert: 'Please log in to access')
    end
  end

end
