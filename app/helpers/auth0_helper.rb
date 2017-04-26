module Auth0Helper

  API_VERSION = 2

  def authenticated?
    session[:userinfo].present?
  end

  # Remember to register the *Allowed Logout URLs* at the following link.
  #
  # @see https://manage.auth0.com/#/account/advanced
  #
  def auth0_logout_url
    auth0_api = Auth0Client.new(credentials)
    auth0_api.logout_url(root_url)
  end

  #---------------------------------------------------------------------------
  private

  def credentials
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
