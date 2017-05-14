require 'auth0'

module Auth0
  module ManagementAPI
    # Get an API access token for the Auth0 API.
    module AccessToken

      # Get a JWT access token for the management API.
      #
      # @return [String] a valid JWT access token.
      #
      # @TODO Cache the access token in Redis and only request a new token if the cached one has expired.
      #
      def self.get
        request_management_access_token!
      end

      def self.decode_token(token:)
        JWT.decode token, nil, false
      end

      # Determine if the given JWT auth token has expired.
      #
      # @param [String] token the JWT token string to be evaluated.
      #
      # @return [Boolean] true if the token has expired.
      #
      def self.jwt_expired?(token:)
        decoded_token = decode_token(token: token)
        Time.now.to_i > decoded_token.reduce({}, :merge).fetch('exp', 0).to_i
      end

      # Get an array of the scopes available to this token.
      #
      # @param [String] token the JWT access token.
      #
      # @return [Array[String]] true if the token has expired.
      #
      def self.jwt_scopes(token:)
        decoded_token = decode_token(token: token)
        decoded_token.reduce({}, :merge).fetch('scope', '').split(' ')
      end

      #---------------------------------------------------------------------------
      # private methods

      def self.auth0_domain
        ENV.fetch('AUTH0_DOMAIN', nil)
      end

      def self.auth0_client_id
        ENV.fetch('AUTH0_MANAGEMENT_API_CLIENT_ID', ENV.fetch('AUTH0_CLIENT_ID', nil))
      end

      def self.auth0_client_secret
        ENV.fetch('AUTH0_MANAGEMENT_API_CLIENT_SECRET', ENV.fetch('AUTH0_CLIENT_SECRET', nil))
      end

      def self.auth0_uri(path: '')
        path = path[1..-1] if path.to_s[0] == '/'
        URI("https://#{auth0_domain}/#{path}")
      end

      def self.management_api_credentials
        {
          grant_type:     'client_credentials',
          client_id:      auth0_client_id,
          client_secret:  auth0_client_secret,
          audience:       "https://#{auth0_domain}/api/v2/"
        }
      end

      def self.net_http(uri:)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      #
      # @raise [Auth0ManagementAPI::Error] if fails to acquire token.
      def self.request_management_access_token!
        uri = auth0_uri path: '/oauth/token'
        request = Net::HTTP::Post.new(uri)
        request['content-type'] = 'application/json'
        request.body = management_api_credentials.to_json

        response = net_http(uri: uri).request(request)
        extract_response_access_token!(response)
      end

      def self.extract_response_access_token!(response)
        body = JSON.parse response.read_body
        validate_access_token_response!(response: response, body: body)
        body['access_token']
      end

      def self.validate_access_token_response!(response:, body:)
        raise Auth0::Exception, body['error_description'] if body.key? 'error_description'
        raise Auth0::Exception, 'Access token in not a JWT Bearer' unless body['token_type'] == 'Bearer'
        raise Auth0::Exception, 'Access token missing' unless body.key? 'access_token'
        raise Auth0::Exception, "#{response.code}: Auth0 management token request failed" if response.code.to_i >= 300
      end

      #---------------------------------------------------------------------------
      # Make the following methods private
      #
      private_class_method :auth0_domain,
                           :auth0_client_id,
                           :auth0_client_secret,
                           :auth0_uri,
                           :management_api_credentials,
                           :net_http,
                           :request_management_access_token!,
                           :extract_response_access_token!,
                           :validate_access_token_response!

    end
  end
end
