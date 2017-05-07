require 'auth0/user'

module Auth0
  #
  # Devise equivalent methods to use with Auth0.
  #
  module DeviseMethods

    # Is the user signed in?
    #
    # @return [Boolean]
    #
    def user_signed_in?
      !auth0_claims.blank?
    end

    # Set the @current_user or redirect to the login page.
    # Name parity with Devise.
    #
    def authenticate_user!
      if user_signed_in?
        @current_user = auth0_user
      else
        session.delete(:userinfo)
        redirect_to(login_path, alert: 'Please log in to access')
      end
    end

    # Auth0 session hash with details about the current user.
    # This method helps ensure compatibility with Devise.
    #
    # @return [Hash] session[:userinfo]
    #
    def current_user
      @current_user
    end

    #------------------------------------------------------------------------
    # The following methods are necessary, but not found in Devise.
    #------------------------------------------------------------------------

    # Get the JWT ID token generated when the user first logged in.
    # @return [String] the user ID token.
    #
    def auth0_id_token
      session.fetch('userinfo', {}).fetch('credentials', {}).fetch('id_token', nil)
    end

    # Get the hash of claims made in the Auth0 JWT.
    # @param [Boolean] verify_signature set false to skip signature validation.
    # @return [Hash] hash of claims.
    #
    def auth0_claims(verify_signature: true)
      @auth0_claims ||= JWT.decode(auth0_id_token,
                                   ENV['AUTH0_CLIENT_SECRET'],
                                   verify_signature,
                                   verify_iat: true,
                                   algorithm: 'HS256').first.with_indifferent_access
    rescue JWT::ExpiredSignature
      {}
    rescue JWT::DecodeError
      {}
    end

    #-------------------------------------------------------------------------
    private

    def auth0_user
      user                = Auth0User.new
      user.sub            = auth0_claims[:sub]
      user.email          = auth0_claims[:email]
      user.email_verified = auth0_claims[:email_verified]
      user.picture        = auth0_claims[:picture]
      user.user_metadata  = auth0_claims[:user_metadata] || {}
      user.app_metadata   = auth0_claims[:app_metadata]  || {}
      user.exp            = auth0_claims[:exp]
      user.iat            = auth0_claims[:iat]
      user.iss            = auth0_claims[:iss]
      user.aud            = auth0_claims[:aud]
      user
    end

  end
end
