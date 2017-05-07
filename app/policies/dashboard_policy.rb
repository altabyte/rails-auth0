# Headless policy for the dashboard controller.
#
DashboardPolicy = Struct.new(:user, :dashboard) do

  def index?
    true
  end

  def super_admin?
    user.app_metadata.fetch('super_admin', false).to_s.downcase.in? %w[true yes 1]
  rescue
    false
  end
end
