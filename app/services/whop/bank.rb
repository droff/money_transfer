class WHOP::Bank
  class << self
    def transfer(sender_account:, receiver_account:, amount:)
      ActiveRecord::Base.transaction do
        sender_account.withdraw(amount)
        receiver_account.deposit(amount)
      end
    end
  end
end
