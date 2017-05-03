module UserProfileHelper

  # Get the time at which the current user's session expires.
  # @return [Time] the current session expiry time.
  #
  def current_user_session_expires_at
    Time.at session.fetch(:userinfo, {}).fetch(:credentials, {}).fetch(:expires_at, 0)
  end

end
