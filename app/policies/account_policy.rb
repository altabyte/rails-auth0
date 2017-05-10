# Access policy for accounts
#
class AccountPolicy < ApplicationPolicy
  include PolicyHelper

  attr_reader :user, :account

  # Construct this policy.
  # @param [Auth0User] user the current_user
  # @param [Account] account the account instance or class.
  #
  def initialize(user, account)
    @user = user
    @account = account
  end

  def index?
    super_admin?
  end

  def new?
    super_admin?
  end

  def create?
    super_admin?
  end

  def show?
    super_admin? || user_belongs_to_account?
  end

  def edit?
    super_admin? || user_belongs_to_account?
  end

  # TODO: Check for account_admin role? Not every account member should be able to edit!
  def update?
    super_admin? || user_belongs_to_account?
  end

  def destroy?
    super_admin?
  end

  def permitted_attributes
    if super_admin?
      %i[name theme code]
    else
      %i[name theme]
    end
  end

  def user_belongs_to_account?
    id = account.is_a?(Account) ? account.id.to_s : account.to_s
    id.in?(account_ids)
  end

  # Scope to limit the accounts accessible by the current user.
  #
  class Scope < Scope
    include PolicyHelper

    attr_reader :user, :scope

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if super_admin?
        scope.all
      else
        Account.where(id: account_ids)
      end
    end
  end
end
