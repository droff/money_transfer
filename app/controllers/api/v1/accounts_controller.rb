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

  def transfer
    receiver_account = Account.find_by(id: params[:receiver_user_id])
    render(json: { error: 'Receiver account not found' }, status: :bad_request) unless receiver_account

    WHOP::Bank.transfer(
      sender_account: current_account,
      receiver_account: receiver_account,
      amount: params[:amount]
    )

    render json: {
      message: 'Transfer successful',
      sender_balance: current_account.balance,
      receiver_balance: receiver_account.balance
    }
  rescue Account::InsufficientBalanceError
    render json: { error: 'Insufficient balance' }, status: :bad_request
  end

  private

  def account_params
    params.permit(:name, :email)
  end
end
