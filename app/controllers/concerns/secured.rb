# Secured should be included in all controllers that must be password protected.
#
module Secured

  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_omniauth?
  end

  #---------------------------------------------------------------------------
  private

  def logged_in_using_omniauth?
    redirect_to(root_path, alert: 'Please log in to access') unless session[:userinfo].present?
  end

end
