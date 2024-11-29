class API::V1::AccountsController < APIController
  before_action :check_current_account, except: :create

  def me
    render json: current_account
  end

  def create
    account = Account.new(account_params)

    if account.save
      render json: account
    else
      render json: account.errors, status: :bad_request
    end
  end

  private

  def account_params
    params.permit(:name, :email)
  end
end
