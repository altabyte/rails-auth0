# Accounts controller
#
class AccountsController < ApplicationController
  include Secured

  before_action :set_account, only: %i[show edit update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :account_not_found

  def index
    authorize Account
    @accounts = policy_scope(Account)
  end

  def new
    authorize Account
    @account = Account.new
  end

  def show
    authorize @account
  end

  def edit
    authorize @account if @account
  end

  def update
    authorize @account
    respond_to do |format|
      if @account.update(permitted_attributes(@account))
        format.html { redirect_to @account, notice: 'Account updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  #---------------------------------------------------------------------------
  private

  def set_account
    @account = Account.where(id: params[:id]).first
    raise ActiveRecord::RecordNotFound, 'Account not found' unless @account
  end

  def account_not_found
    redirect_to dashboard_path, alert: 'Account not found'
  end
end
