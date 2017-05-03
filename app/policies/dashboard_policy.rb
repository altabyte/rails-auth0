# Headless policy for the dashboard controller.
#
DashboardPolicy = Struct.new(:user, :dashboard) do

  def index?
    true
  end

  def super_admin?
    app_metadata.fetch('super_admin', false)
  end

  #---------------------------------------------------------------------------
  private

  def app_metadata
    user.fetch(:extra, {}).fetch(:raw_info, {}).fetch(:app_metadata, {})
  end
end
