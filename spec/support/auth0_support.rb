module Auth0RequestSpecHelper

  # Stub the value of `session[:userinfo]` with Auth0 user credentials.
  #
  def assign_session_for_auth0(email: Faker::Internet.email, email_verified: true, id_token: nil)
    session[:userinfo] = auth0_hash(email: email, email_verified: email_verified, id_token: id_token)
  end


  # Set the value of `request.env['omniauth.auth']` for use in the Auth0 callback method after registration or login.
  # `Auth0Controller#callback` is responsible for assigning `session[:userinfo]`.
  #
  def assign_request_env_for_auth0(email: Faker::Internet.email, email_verified: true, id_token: nil)
    request.env['omniauth.auth'] = auth0_hash(email: email, email_verified: email_verified, id_token: id_token)
  end


  #-----------------------------------------------------------------------------
  private

  def auth0_hash(email: Faker::Internet.email, email_verified: true, id_token: nil)
    uid = SecureRandom.hex(24)
    nickname ||= email.split('@').first
    credentials_token ||= '304mMerJESt6zBBE'

    # ID Token expires: '2020-12-31T23:59'
    # @see https://jwt.io/
    id_token ||= 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZW1haWwiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImV4cCI6MTYwOTQ1OTE0MH0.gnCidNCNEGy4zPWqmdDIaMk3QHI10a2ckAb2txaxgWg'

    json = <<-EOQ
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
                 "id_token": "#{id_token}",
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
    claims = JSON.parse(Base64.decode64(jwt.split('.').second)).with_indifferent_access
    puts claims.to_yaml
    puts "JWT expires:  #{Time.at(claims[:exp])}"
    hash
  end

end
