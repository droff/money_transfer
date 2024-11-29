class Account < ApplicationRecord
  class InsufficientBalanceError < StandardError; end

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  def deposit(amount)
    self.update(balance: self.balance + amount)
  end

  def withdraw(amount)
    raise InsufficientBalanceError if amount > self.balance
    self.update(balance: self.balance - amount)
  end
end
