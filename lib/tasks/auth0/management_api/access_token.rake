require 'auth0/management_api/access_token'

namespace :auth0 do
  namespace :management_api do

    # Get an Auth0 management access token.
    #
    # ./bin/rake auth0:management_api:access_token
    #
    desc 'Get an Auth0 management API access token'
    task access_token: :environment do
      begin
        token = Auth0::ManagementAPI::AccessToken.get
        decoded = Auth0::ManagementAPI::AccessToken.decode_token(token: token)
        STDERR.puts JSON.pretty_generate decoded
        STDERR.puts "\n\n## Expires at: #{Time.at decoded.first.fetch('exp', 0)}\n\n"
        STDOUT.puts token
      rescue => e
        STDERR.puts e.message
      end
    end
  end
end
