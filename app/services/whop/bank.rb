class WHOP::Bank
  DEPOSIT_TOKENS = {
    100 => '0XZ1JHd6ICZpxWY2JCLwADMxojI5FGblRmIsICMwEjI6ICduV3btFmIsICdpN3bwVGZiojIlBXe0Jye',
    200 => 'QflVnc0pjIklGbhZnIsADM0ojI5FGblRmIsICMwIjI6ICduV3btFmIsICdpN3bwVGZiojIlBXe0Jye'
  }.freeze

  WITHDRAW_TOKENS = {
    50 => '9VWdyRnOiQWasFmdiwCMzojI5FGblRmIsICM1IiOiQnb19WbhJCLicXYyRGa0l2diojIlBXe0Jye'
  }.freeze

  class << self
    def transfer(sender_account:, receiver_account:, amount:)
      if sender_account.nil? || receiver_account.nil? || !amount.is_a?(Numeric) || amount < 1
        raise WHOP::Errors::ValidationError
      end

      ActiveRecord::Base.transaction do
        sender_account.withdraw(amount)
        receiver_account.deposit(amount)
      end
    end

    def deposit(account:, amount:)
      raise WHOP::Errors::ValidationError if account.nil? || !amount.is_a?(Numeric)
      raise WHOP::Errors::InvalidToken unless DEPOSIT_TOKENS[amount]

      client = WHOP::Client.init
      if client.deposit(DEPOSIT_TOKENS[amount], amount)
        account.deposit(amount)
      end
    end

    def withdraw(account:, amount:)
      raise WHOP::Errors::ValidationError if account.nil? || !amount.is_a?(Numeric)
      raise WHOP::Errors::InvalidToken unless WITHDRAW_TOKENS[amount]

      client = WHOP::Client.init
      if client.withdraw(WITHDRAW_TOKENS[amount], amount)
        account.withdraw(amount)
      end
    end
  end
end
