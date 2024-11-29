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
      render_error(account.errors)
    end
  end

  def transfer
    receiver_account = Account.find_by(id: params[:receiver_user_id])
    render_error('Receiver account not found') unless receiver_account

    WHOP::Bank.transfer(
      sender_account: current_account,
      receiver_account: receiver_account,
      amount: amount
    )

    render json: {
      message: 'Transfer successful',
      sender_balance: current_account.balance,
      receiver_balance: receiver_account.balance
    }
  rescue Account::InsufficientBalanceError
    render_error('Insufficient balance')
  end

  private

  def account_params
    params.permit(:name, :email)
  end

  def amount
    params[:amount] && params[:amount].to_i
  end
end
