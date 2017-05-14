require 'rails_helper'
require 'auth0'
require 'auth0/management_api/access_token'

describe 'Auth0::ManagementAPI::AccessToken' do

  context 'Invalid credentials' do
    it 'Fails when AUTH0_DOMAIN is invalid' do
      ClimateControl.modify AUTH0_DOMAIN: 'INVALID' do
        # Probably not necessary to test this, as it may be hitting someone else's API.
        # expect { Auth0::ManagementAPI::AccessToken.get }.to raise_error(SocketError)
      end
    end

    it 'Fails when Auth0 Client ID is invalid' do
      allow(Auth0::ManagementAPI::AccessToken).to receive(:auth0_client_id).and_return('INVALID')
      expect { Auth0::ManagementAPI::AccessToken.get }.to raise_error(Auth0::Exception)
    end

    it 'Fails when Auth0 Client Secret is invalid' do
      allow(Auth0::ManagementAPI::AccessToken).to receive(:auth0_client_secret).and_return('INVALID')
      expect { Auth0::ManagementAPI::AccessToken.get }.to raise_error(Auth0::Exception)
    end
  end

  describe 'private methods' do
    let(:private_methods) do
      %i[
        auth0_domain
        auth0_client_id
        auth0_secret
        auth0_uri
        management_api_credentials
        net_http
        request_management_access_token!
        extract_response_access_token!
        validate_access_token_response!
      ]
    end

    it 'does not respond to private methods' do
      private_methods.each do |private_method|
        expect(Auth0::ManagementAPI::AccessToken).not_to respond_to private_method
      end
    end
  end

  describe '#get' do
    it { expect(Auth0::ManagementAPI::AccessToken).to respond_to :get }
    it { expect { Auth0::ManagementAPI::AccessToken.get }.not_to raise_error }

    describe 'token' do
      before(:all) do
        @token = Auth0::ManagementAPI::AccessToken.get
        puts @token
      end
      let(:token) { @token }

      it { expect(token).to be_a String }
      it { expect(token.split('.').count).to eq 3 }
      it { puts Auth0::ManagementAPI::AccessToken.decode_token(token: token) }
      it { puts "Expires: #{Time.at Auth0::ManagementAPI::AccessToken.decode_token(token: token).first.fetch('exp', 0)}" }
      it { expect(Auth0::ManagementAPI::AccessToken.jwt_expired?(token: token)).to be false }
      it { expect(Auth0::ManagementAPI::AccessToken.jwt_scopes(token: token)).to be_a Array }
      it { puts Auth0::ManagementAPI::AccessToken.jwt_scopes(token: token).join("\n") }
    end
  end

  describe 'API calls using access token' do
    before(:all) do
      @token = Auth0::ManagementAPI::AccessToken.get
      @auth0 = Auth0Client.new(client_id: ENV.fetch('AUTH0_CLIENT_ID', ''),
                               token: @token,
                               domain: ENV.fetch('AUTH0_DOMAIN', ''),
                               timeout: 30.seconds,
                               api_version: 2)

    end
    let(:auth0_api) { @auth0 }

    describe '#get_users' do
      describe 'getting a page of users' do
        let(:page)     { 0 }
        let(:per_page) { 50 }

        subject(:users) { auth0_api.get_users per_page: per_page, page: page }

        it { puts users }
        it { is_expected.to be_a Array }
      end

      describe 'total number of users' do
        subject(:users) { auth0_api.get_users include_totals: true }

        it { puts users }
        it { is_expected.to be_a Hash }
        it { is_expected.to have_key 'total' }
        it { expect(users['total']).to be_a Integer }
        it { expect(users['total']).to be >= 0 }
        it { puts "Total number of users: #{users['total']}" }
      end
    end

    describe '#create_user' do
      context 'user does not exist' do
        before(:all) do
          @name = 'User Name'
          @email = 'example@email.com'
          @password = 'Password123'
          @options = {
            connection: 'Username-Password-Authentication',
            email: @email,
            password: @password,
            name: @name,
            email_verified: false,
            verify_email: false,    # Prevent confirmation email
            user_metadata: {},
            app_metadata: {}
          }
          expect { @user = @auth0.create_user(@name, @options) }.not_to raise_exception
        end

        after(:all) do
          return unless @user
          user_id = @user['user_id']
          @auth0.delete_user(user_id)
        end

        let(:name)  { @name }
        let(:email) { @email }

        subject(:user) { @user }

        it { is_expected.not_to be_nil }
        it { is_expected.to be_a Hash }
        it { puts JSON.pretty_generate user.to_json }
        it { expect(user).to have_key('user_id') }
        it { expect(user).to have_key('name') }
        it { expect(user).to have_key('email') }
        it { expect(user).to have_key('email_verified') }
        it { expect(user).to have_key('user_metadata') }
        it { puts user['user_id'] }
        it { expect(user['name']).to eq name }
        it { expect(user['email']).to eq email }
      end
    end
  end
end
