# Dashboard controller
#
class DashboardController < ApplicationController
  include Secured

  before_action { authorize :dashboard }

  def index; end

  def super_admin; end
end
