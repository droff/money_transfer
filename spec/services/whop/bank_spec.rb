require 'rails_helper'

describe WHOP::Bank do
  describe '.transfer' do
    let(:sender_account) { create(:account, name: 'sender', email: 'sender@example.com', balance: 100) }
    let(:receiver_account) { create(:account, name: 'receiver', email: 'receiver@example.com', balance: 100) }
    let(:amount) { 50 }

    it 'transfers money' do
      described_class.transfer(
        sender_account: sender_account,
        receiver_account: receiver_account,
        amount: amount
      )

      expect(sender_account.balance).to eq(50)
      expect(receiver_account.balance).to eq(150)
    end

    it 'raises an error if sender account has insufficient balance' do
      expect {
        described_class.transfer(
          sender_account: sender_account,
          receiver_account: receiver_account,
          amount: 1_000_000
        )
      }.to raise_error(Account::InsufficientBalanceError)
    end

    it 'raises a validation error if sender account is empty' do
      expect {
        described_class.transfer(
          sender_account: nil,
          receiver_account: receiver_account,
          amount: 10
        )
      }.to raise_error(WHOP::Bank::ValidationError)
    end

    it 'raises a validation error if receiver account is empty' do
      expect {
        described_class.transfer(
          sender_account: sender_account,
          receiver_account: nil,
          amount: 10
        )
      }.to raise_error(WHOP::Bank::ValidationError)
    end

    it 'raises a validation error if amount less that 1' do
      expect {
        described_class.transfer(
          sender_account: sender_account,
          receiver_account: receiver_account,
          amount: -100
        )
      }.to raise_error(WHOP::Bank::ValidationError)
    end
  end
end
