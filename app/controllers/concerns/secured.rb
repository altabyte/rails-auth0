# Secured should be included in all controllers that must be password protected.
#
module Secured

  extend ActiveSupport::Concern
  include Auth0::DeviseMethods if defined? Auth0

  included do
    before_action :authenticate_user!
    after_action :verify_authorized
  end

end
