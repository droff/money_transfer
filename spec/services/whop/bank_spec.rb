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
      }.to raise_error(WHOP::Errors::InsufficientBalance)
    end

    it 'raises a validation error if sender account is empty' do
      expect {
        described_class.transfer(
          sender_account: nil,
          receiver_account: receiver_account,
          amount: 10
        )
      }.to raise_error(WHOP::Errors::ValidationError)
    end

    it 'raises a validation error if receiver account is empty' do
      expect {
        described_class.transfer(
          sender_account: sender_account,
          receiver_account: nil,
          amount: 10
        )
      }.to raise_error(WHOP::Errors::ValidationError)
    end

    it 'raises a validation error if amount less that 1' do
      expect {
        described_class.transfer(
          sender_account: sender_account,
          receiver_account: receiver_account,
          amount: -100
        )
      }.to raise_error(WHOP::Errors::ValidationError)
    end
  end

  describe '.deposit' do
    let(:account) { create(:account, balance: 1) }
    let(:amount) { 100 }
    let(:body) { { whop_bank_token: WHOP::Bank::DEPOSIT_TOKENS[amount], amount: amount } }
    let(:uri) { "#{WHOP::Client::API_URL}/deposit" }

    it 'deposits money' do
      http_call = stub_request(:post, uri)
        .with(body: body, headers: { 'Content-Type': 'application/json' })
        .to_return(status: 200)

      described_class.deposit(account: account, amount: amount)

      expect(http_call).to have_been_made.once
      expect(account.balance).to eq(101)
    end

    it 'raises with invalid token' do
      expect {
        described_class.deposit(account: account, amount: 10)
      }.to raise_error(WHOP::Errors::InvalidToken)

      expect(account.balance).to eq(1)
    end

    it 'keeps balance untouched if client returns an error' do
      http_call = stub_request(:post, uri)
        .with(body: body, headers: { 'Content-Type': 'application/json' })
        .to_return(status: 500)

      described_class.deposit(account: account, amount: amount)

      expect(http_call).to have_been_made.once
      expect(account.balance).to eq(1)
    end
  end

  describe '.withdraw' do
    let(:account) { create(:account, balance: 100) }
    let(:amount) { 50 }
    let(:body) { { whop_bank_token: WHOP::Bank::WITHDRAW_TOKENS[amount], amount: amount } }
    let(:uri) { "#{WHOP::Client::API_URL}/withdraw" }

    it 'withdraws money' do
      http_call = stub_request(:post, uri)
        .with(body: body, headers: { 'Content-Type': 'application/json' })
        .to_return(status: 200)

      described_class.withdraw(account: account, amount: amount)

      expect(http_call).to have_been_made.once
      expect(account.balance).to eq(50)
    end

    it 'raises with invalid token' do
      expect {
        described_class.withdraw(account: account, amount: 10)
      }.to raise_error(WHOP::Errors::InvalidToken)

      expect(account.balance).to eq(100)
    end

    it 'keeps balance untouched if client returns an error' do
      http_call = stub_request(:post, uri)
        .with(body: body, headers: { 'Content-Type': 'application/json' })
        .to_return(status: 500)

      described_class.withdraw(account: account, amount: 50)

      expect(http_call).to have_been_made.once
      expect(account.balance).to eq(100)
    end
  end
end
