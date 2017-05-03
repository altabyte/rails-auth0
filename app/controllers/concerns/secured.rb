# Secured should be included in all controllers that must be password protected.
#
module Secured

  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

end
