require 'auth0/management_api/access_token'

# Allow users to update their Auth0 user profiles.
#
class UserProfileController < ApplicationController
  include Secured

  before_action :skip_authorization, only: %i[edit update]

  rescue_from Auth0::BadRequest do |exception|
    info = JSON.parse(exception.message)
    puts info['error']
    puts info['message']
    redirect_to user_profile_path, alert: info['error']
  end

  def edit
    @user = current_user
  end

  def update
    info = auth0_api.patch_user(current_user.auth0_id, user_params)
    session_auth0 = JSON.parse(session[:auth0_json] || '{}').with_indifferent_access
    session_auth0[:extra][:raw_info] = info if session_auth0.fetch(:extra, {}).fetch(:raw_info, false)
    session[:auth0_json] = session_auth0.to_json
    redirect_to dashboard_path, notice: 'User profile updated'
  end

  #---------------------------------------------------------------------------
  private

  def auth0_api
    return @auth0_api if @auth0_api
    access_token = Auth0::ManagementAPI::AccessToken.get
    @auth0_api ||= Auth0Client.new(client_id: ENV.fetch('AUTH0_CLIENT_ID', ''),
                                   token: access_token,
                                   domain: ENV.fetch('AUTH0_DOMAIN', ''),
                                   timeout: 30.seconds,
                                   api_version: 2)
  end

  def user_params
    userinfo = { user_metadata: user_metadata_params }
    userinfo[:email] = params[:user][:email] unless params[:user][:email] == current_user.email
    userinfo
  end

  def user_metadata_params
    {
      name: params[:user][:name]
    }
  end
end
