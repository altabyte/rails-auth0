require 'auth0/management_api/access_token'

namespace :auth0 do
  namespace :management_api do

    # Get the Raw JSON profile for the given user ID.
    #
    # ./bin/rake auth0:management_api:user_profile['auth0|123456']
    #
    # @see https://github.com/auth0/ruby-auth0/blob/master/lib/auth0/api/v2/users.rb
    #
    desc 'Get the raw JSON profile for a user.'
    task :user_profile, [:provider_id] => :environment do |_, args|
      begin
        provider_id = args[:provider_id]
        user_json = auth0_client.user(provider_id)
        STDOUT.puts JSON.pretty_generate(user_json)
      rescue => e
        STDERR.puts e.message
      end
    end
  end
end

#-----------------------------------------------------------------------------
private

def auth0_client
  Auth0Client.new(client_id: ENV.fetch('AUTH0_CLIENT_ID', ''),
                  token: Auth0::ManagementAPI::AccessToken.get,
                  domain: ENV.fetch('AUTH0_DOMAIN', ''),
                  timeout: 30.seconds,
                  api_version: 2)
end
