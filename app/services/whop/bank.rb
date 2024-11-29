class WHOP::Bank
  class ValidationError < StandardError; end
  class << self
    def transfer(sender_account:, receiver_account:, amount:)
      if sender_account.nil? || receiver_account.nil? || !amount.is_a?(Numeric) || amount < 1
        raise (ValidationError)
      end

      ActiveRecord::Base.transaction do
        sender_account.withdraw(amount)
        receiver_account.deposit(amount)
      end
    end
  end
end
