if defined? Devise

  # There are currently no Devise RSpec helpers to use in type: :request specs.
  # So we create our own DeviseRequestSpecHelpers module and configure it in rails_helper.rb
  #
  module DeviseRequestSpecHelpers

    include Warden::Test::Helpers

    def sign_in(resource_or_scope, resource = nil)
      resource ||= resource_or_scope
      scope = Devise::Mapping.find_scope!(resource_or_scope)
      login_as(resource, scope: scope)
    end

    def sign_out(resource_or_scope)
      scope = Devise::Mapping.find_scope!(resource_or_scope)
      logout(scope)
    end

  end


  # This support package contains modules for authenticating
  # devise users for request specs.
  #
  # Add the following line to RSpec.configure block
  #
  #   config.include ValidUserRequestHelper, type: :request
  #
  # @see http://blog.sorryapp.com/2013/03/22/request-and-controller-specs-with-devise.html
  #
  module ValidUserRequestHelper

    # Define a method which signs in as a valid user.
    def sign_in_as_a_valid_user
      @user ||= FactoryGirl.create :user # or we could use a fixture.

      # We action the login request using the parameters before we begin.
      # The login requests will match these to the user we just created in the factory, and authenticate us.
      post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
    end

  end


  module RedirectUnauthenticated

    def redirects_to_login_page_when_not_authenticated(action, attributes = {}, valid_session = {})
      sign_out current_user if defined?(current_user) && current_user
      get action, params: attributes, session: valid_session
      expect(response).to redirect_to new_user_session_path
    end

  end
end
