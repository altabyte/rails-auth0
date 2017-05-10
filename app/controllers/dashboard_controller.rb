# Dashboard controller
#
class DashboardController < ApplicationController
  include Secured

  before_action { authorize :dashboard }

  def index
    skip_policy_scope
  end

  def super_admin; end
end
