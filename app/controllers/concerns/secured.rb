# Secured should be included in all controllers that must be password protected.
#
module Secured

  extend ActiveSupport::Concern
  include Auth0::DeviseMethods if defined? Auth0

  included do
    before_action :authenticate_user!
    after_action :verify_authorized if Rails.env.development?
    after_action :verify_policy_scoped, except: %i[new create show edit update destroy] if Rails.env.development?
  end

end
