module UserProfileHelper

  # Get the Auth0 user ID of the currently logged in user.
  # @return [String] Auth0 user ID
  #
  def current_user_id
    uid = session.fetch(:userinfo, {}).fetch(:uid, nil)
    uid = uid.split('|').last if uid.match?(/^auth0|/i)
    uid
  end

  # Get the email of the currently logged in user.
  def current_user_email
    email = session.fetch(:userinfo, {}).fetch(:info, {}).fetch(:email, nil)
    email&.downcase
  end

  def current_user_metadata
    session.fetch(:userinfo, {}).fetch(:extra, {}).fetch(:raw_info, {}).fetch(:user_metadata, {})
  end

  def current_user_app_metadata
    session.fetch(:userinfo, {}).fetch(:extra, {}).fetch(:raw_info, {}).fetch(:app_metadata, {})
  end

  # Get the name of the currently logged in user.
  #
  def current_user_name
    current_user_metadata.fetch(:name, nil)
  end

  # Get the time at which the current user's session expires.
  # @return [Time] the current session expiry time.
  #
  def current_user_session_expires_at
    Time.at session.fetch(:userinfo, {}).fetch(:credentials, {}).fetch(:expires_at, 0)
  end

end
