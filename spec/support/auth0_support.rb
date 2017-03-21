module Auth0RequestSpecHelper

  # Stub the value of `session[:userinfo]` with Auth0 user credentials.
  #
  def assign_session_for_auth0(email: Faker::Internet.email, email_verified: true, jwt_base64: nil)
    session[:userinfo] = auth0_hash(email: email, email_verified: email_verified, jwt_base64: jwt_base64)
  end


  # Set the value of `request.env['omniauth.auth']` for use in the Auth0 callback method after registration or login.
  # `Auth0Controller#callback` is responsible for assigning `session[:userinfo]`.
  #
  def assign_request_env_for_auth0(email: Faker::Internet.email, email_verified: true, jwt_base64: nil)
    request.env['omniauth.auth'] = auth0_hash(email: email, email_verified: email_verified, jwt_base64: jwt_base64)
  end


  #-----------------------------------------------------------------------------
  private

  def auth0_hash(email: Faker::Internet.email, email_verified: true, jwt_base64: nil)
    uid = SecureRandom.hex(24)
    nickname ||= email.split('@').first
    credentials_token ||= '304mMerJESt6zBBE'
    jwt_base64 ||= 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiYWx0YWJ5dGVAZ21haWwuY29tIiwiZW1haWwiOiJhbHRhYnl0ZUBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicGljdHVyZSI6Imh0dHBzOi8vcy5ncmF2YXRhci5jb20vYXZhdGFyL2ZkNmM0MjM2ODBkNDZmMDkyMzkzM2Y3ZThhYTc2Y2JjP3M9NDgwJnI9cGcmZD1odHRwcyUzQSUyRiUyRmNkbi5hdXRoMC5jb20lMkZhdmF0YXJzJTJGYWwucG5nIiwiaXNzIjoiaHR0cHM6Ly9iZWFkY2FuLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1ODdlYmNiZjcyOTJkNDY0Yzg2MDU0NzYiLCJhdWQiOiJpUTlaQU1jd2ZtM0hpUzcxTHZCSEFZTEI1djl5NTJLcyIsImV4cCI6MTQ4NDkxMTU1NCwiaWF0IjoxNDg0ODc1NTU0fQ.eibvh6guJnaQi4TfyfEfGwYEwdITf3Vm8X19PQ1UEO8'

    json = <<EOQ
{
  "provider": "auth0",
  "uid": "auth0|#{uid}",
  "info": {
    "name": "#{email}",
    "email": "#{email}",
    "nickname": "#{nickname}",
    "first_name": null,
    "last_name": null,
    "location": null,
    "image": null
  },
  "credentials": {
    "token": "#{credentials_token}",
    "expires": true,
    "id_token": "#{jwt_base64}",
    "token_type": "Bearer"
  },
  "extra": {
    "raw_info": {
      "email_verified": #{email_verified},
      "email": "#{email}",
      "clientID": "#{Rails.application.secrets.auth0_client_id}",
      "updated_at": "#{(Time.now.utc - 2.minutes).iso8601(3)}",
      "name": "#{email}",
      "picture": null,
      "user_id": "auth0|#{uid}",
      "nickname": "#{nickname}",
      "identities": [
        {
          "user_id": "#{uid}",
          "provider": "auth0",
          "connection": "Username-Password-Authentication",
          "isSocial": false
        }
      ],
      "created_at": "#{(Time.now.utc - 2.days).iso8601(3)}",
      "sub": "auth0|#{uid}"
    }
  }
}
EOQ

    hash = JSON.parse(json).with_indifferent_access
    jwt = hash[:credentials][:id_token]
    # bearer = JSON.parse(Base64.decode64(jwt.split('.').first)).with_indifferent_access
    claims = JSON.parse(Base64.decode64(jwt.split('.').second)).with_indifferent_access
    puts claims.to_yaml
    puts "JWT expires:  #{Time.at(claims[:exp])}"
    hash
  end

end
