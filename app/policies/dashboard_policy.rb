# Headless policy for the dashboard controller.
#
DashboardPolicy = Struct.new(:user, :dashboard) do
  include PolicyHelper

  def index?
    true
  end

end
