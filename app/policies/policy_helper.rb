# Helper methods to be included in policies and policy scopes.
#
module PolicyHelper

  # Determine if the current user is a super admin.
  # @return [Boolean] true if super admin.
  def super_admin?
    user.app_metadata.fetch('super_admin', false).to_s.downcase.in? %w[true yes 1]
  rescue
    false
  end

  # Get a list of the account IDs from Auth0 that the user belongs to.
  # @return [Array [String]] a list of UUIDs.
  def account_ids
    user.app_metadata.fetch('account_ids', [])
  end

end
