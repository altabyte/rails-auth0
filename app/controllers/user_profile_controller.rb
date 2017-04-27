require 'auth0/api_management_access_token'

# Allow users to update their Auth0 user profiles.
#
class UserProfileController < ApplicationController
  include Secured

  def edit
    @user = session[:userinfo]
  end

  def update
    info = auth0_api.patch_user(current_user_id, user_params)
    update_user_email(info['email'])
    update_user_name(info['user_metadata']['name'])
    redirect_to dashboard_path, notice: 'User profile updated'
  end

  #---------------------------------------------------------------------------
  private

  def current_user_id
    session[:userinfo].fetch(:uid, nil)
  end

  def current_user_email
    session[:userinfo].fetch(:info, {}).fetch(:email, nil)
  end

  def auth0_api
    return @auth0_api if @auth0_api
    access_token = Auth0::API::ManagementAccessToken.get
    @auth0_api ||= Auth0Client.new(client_id: ENV.fetch('AUTH0_CLIENT_ID', ''),
                                   token: access_token,
                                   domain: ENV.fetch('AUTH0_DOMAIN', ''),
                                   timeout: 30.seconds,
                                   api_version: 2)
  end

  def user_params
    userinfo = { user_metadata: user_metadata_params }
    userinfo[:email] = params[:user][:email] unless params[:user][:email] == current_user_email
    userinfo
  end

  def user_metadata_params
    {
      name: params[:user][:name]
    }
  end

  def update_user_email(email)
    session[:userinfo][:info][:email] = email
    session[:userinfo][:extra][:raw_info][:email] = email
  end

  def update_user_name(name)
    session[:userinfo][:extra][:raw_info][:user_metadata][:name] = name
  end
end
