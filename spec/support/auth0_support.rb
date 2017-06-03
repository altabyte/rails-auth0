module Auth0RequestSpecHelper

  # Stub the value of `session[:userinfo]` with Auth0 user credentials.
  #
  def assign_session_for_auth0(user: create_user, params: {})
    auth_hash = omniauth_auth(user: user, params: params)
    session[:auth0_json] = auth_hash.to_json
    session[:id_token]   = auth_hash.credentials.id_token
    session[:expires_at] = auth_hash.credentials.expires_at
  end

  # Set the value of `request.env['omniauth.auth']` for use in the Auth0 callback method after registration or login.
  # `Auth0Controller#callback` is responsible for assigning `session[:userinfo]`.
  #
  def assign_request_env_for_auth0(user: create_user, params: {})
    request.env['omniauth.auth'] = omniauth_auth(user: user, params: params)
  end

  def create_user(params = {})
    user = Auth0::UserStruct.new
    user.sub            = params.fetch(:auth0_id,       "auth0|#{SecureRandom.hex(24)}")
    user.email          = params.fetch(:email,          Faker::Internet.email)
    user.email_verified = params.fetch(:email_verified, true)
    user.picture        = params.fetch(:avatar,         nil)
    user.user_metadata  = params.fetch(:user_metadata,  {}).with_indifferent_access
    user.app_metadata   = params.fetch(:app_metadata,   {}).with_indifferent_access
    user.iss            = params.fetch(:issuer,         ENV.fetch('AUTH0_DOMAIN', 'https://example.auth0.com/'))
    user.aud            = params.fetch(:client_id,      SecureRandom.hex(32))
    user.iat            = params.fetch(:issued_at,      Time.now.utc - 1.minute).to_i
    user.exp            = params.fetch(:expires_at,     Time.now.utc + 10.minutes).to_i
    user
  end

  #-----------------------------------------------------------------------------
  private

  def omniauth_auth(user:, params: {})
    hash = OmniAuth::AuthHash.new
    hash.provider = user.provider
    hash.uid = user.auth0_id
    assign_omniauth_auth_info(omniauth_auth: hash, user: user, params: params)
    assign_omniauth_auth_credentials(omniauth_auth: hash, user: user, params: params)
    assign_omniauth_auth_extra(omniauth_auth: hash, user: user, params: params)
    hash
  end

  def assign_omniauth_auth_info(omniauth_auth:, user:, params:)
    omniauth_auth.info = {
      email: user.email
    }
  end

  def assign_omniauth_auth_credentials(omniauth_auth:, user:, params:)
    omniauth_auth.credentials = {
      'token' => params.fetch(:token, SecureRandom.hex(24)),
      'id_token' => user.to_jwt,
      'expires' => true,
      'expires_at' => user.exp,
      'token_type' => 'Bearer'
    }
    omniauth_auth.credentials[:refresh_token] = params[:refresh_token] if params.key?(:refresh_token)
  end

  def assign_omniauth_auth_extra(omniauth_auth:, user:, params:)
    omniauth_auth.extra = {
      raw: {
        email: user.email,
        email_verified: params.fetch(:email_verified, true),
        picture: params.fetch(:avatar, nil)
      }
    }
  end

end
