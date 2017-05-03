module Auth0Helper

  API_VERSION = 2

  #---------------------------------------------------------------------------
  private

  # Is the user signed in?
  #
  # @return [Boolean]
  #
  def user_signed_in?
    session[:userinfo].present?
  end

  alias authenticated? user_signed_in?

  # Set the @current_user or redirect to the login page.
  # Name parity with Devise.
  #
  def authenticate_user!
    if user_signed_in?
      if session_expired?
        session.delete(:userinfo)
        redirect_to(login_path, alert: 'Session expired')
      else
        @current_user = session[:userinfo]
      end
    else
      redirect_to(login_path, alert: 'Please log in to access')
    end
  end

  # Determine if the current session has expired.
  #
  # @return [Boolean] true if the session has expired.
  #
  def session_expired?
    JWT.decode(auth0_id_token, nil, false)
    false
  rescue JWT::ExpiredSignature
    true
  end

  # Auth0 session hash with details about the current user.
  # This method helps ensure compatibility with Devise.
  #
  # @return [Hash] session[:userinfo]
  #
  def current_user
    @current_user
  end

  # Retrieve the metadata hash containing user editable data, such as name, theme, phone number etc.
  #
  # @return [Hash] user metadata.
  #
  def current_user_metadata
    session.fetch(:userinfo, {}).fetch(:extra, {}).fetch(:raw_info, {}).fetch(:user_metadata, {})
  end

  # Retrieve the metadata hash containing application data specific to the user, such as roles etc.
  #
  # @return [Hash] application metadata.
  #
  def current_user_app_metadata
    session.fetch(:userinfo, {}).fetch(:extra, {}).fetch(:raw_info, {}).fetch(:app_metadata, {})
  end

  # Get the JWT ID token generated when the user first logged in.
  #
  # @return [String] the user ID token.
  #
  def auth0_id_token
    session[:userinfo].fetch('credentials', {}).fetch('id_token', nil)
  end

  # Get the Auth0 user ID of the currently logged in user.
  #
  # @return [String] Auth0 user ID
  #
  def current_user_id
    uid = session.fetch(:userinfo, {}).fetch(:uid, nil)
    uid
  end

  # Get the email address of the currently logged in user.
  #
  # @return [String] email address.
  #
  def current_user_email
    email = session.fetch(:userinfo, {}).fetch(:info, {}).fetch(:email, nil)
    email&.downcase
  end

  # Get the name of the currently logged in user.
  #
  # @return [String] current user's name.
  #
  def current_user_name
    current_user_metadata.fetch(:name, nil)
  end

  # Remember to register the *Allowed Logout URLs* at the following link.
  #
  # @see https://manage.auth0.com/#/account/advanced
  #
  def auth0_logout_url
    auth0_api = Auth0Client.new(auth0_credentials)
    auth0_api.logout_url(root_url)
  end

  def auth0_credentials
    creds = {
      api_version: API_VERSION,
      domain:      Rails.application.secrets.auth0_domain,
      client_id:   Rails.application.secrets.auth0_client_id
    }

    if API_VERSION == 1
      creds.merge(client_secret: Rails.application.secrets.auth0_client_secret)
    elsif API_VERSION == 2
      creds.merge(token: auth0_id_token)
    end
  end

end
