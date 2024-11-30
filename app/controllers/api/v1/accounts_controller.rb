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
      render_error account.errors
    end
  end

  def transfer
    receiver_account = Account.find_by(id: params[:receiver_user_id])
    return render_error('Receiver account not found') unless receiver_account

    WHOP::Bank.transfer(sender_account: current_account, receiver_account: receiver_account, amount: amount)

    render json: {
      message: 'Transfer successful',
      sender_balance: current_account.balance.to_f,
      receiver_balance: receiver_account.balance.to_f
    }
  rescue WHOP::Errors::InsufficientBalance
    render_error 'Insufficient balance'
  end

  def deposit
    WHOP::Bank.deposit(account: current_account, amount: amount)

    render json: { message: 'Deposit successful', balance: current_account.balance.to_f }
  rescue WHOP::Errors::InvalidToken
    render_error 'Invalid bank token'
  end

  def withdraw
    WHOP::Bank.withdraw(account: current_account, amount: amount)

    render json: { message: 'Withdrawal successful', balance: current_account.balance.to_f }
  rescue WHOP::Errors::InvalidToken
    render_error 'Invalid bank token'
  end

  private

  def account_params
    params.permit(:name, :email)
  end

  def amount
    params[:amount] && params[:amount].to_i
  end
end
