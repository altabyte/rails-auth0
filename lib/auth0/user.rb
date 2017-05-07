# User model wrapping Auth0 JWT values.
#
Auth0User = Struct.new(:sub,
                       :email,
                       :email_verified,
                       :picture,
                       :user_metadata,
                       :app_metadata,
                       :exp,
                       :iat,
                       :iss,
                       :aud) do

  alias_method :auth0_id,  :sub
  alias_method :issuer,    :iss
  alias_method :client_id, :aud
  alias_method :avatar,    :picture

  def provider
    sub.split('|').first
  end

  def name
    user_metadata.fetch('name', nil)
  end

  def expires_at
    Time.at exp.to_i
  end

  def issued_at
    Time.at iat.to_i
  end

  def to_jwt(secret: ENV['AUTH0_CLIENT_SECRET'], algorithm: 'HS256')
    JWT.encode(to_h, secret, algorithm)
  end

end
