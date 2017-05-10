# Accounts controller
#
class AccountsController < ApplicationController
  include Secured

  before_action :set_account, only: %i[show edit update destroy]

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
    authorize @account
  end

  def update
    authorize @account
    respond_to do |format|
      if @account.update(account_params)
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
  end

  def account_params
    params.require(:account).permit(:name, :theme)
  end
end
