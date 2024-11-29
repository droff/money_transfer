require 'rails_helper'

describe Account do
  let(:name) { 'John Doe' }
  let(:email) { 'john.doe@example.com' }

  context 'validations' do
    it 'throws an error if name is empty' do
      account = Account.new(email: email)
      expect(account.valid?).to be_falsey
    end

    it 'throws an error if email is empty' do
      account = Account.new(name: name)
      expect(account.valid?).to be_falsey
    end

    it 'throws an error if email is not unique' do
      email = 'john.doe@example.org'
      Account.create(name: name, email: email)

      account = Account.new(name: 'JD', email: email)
      expect(account.valid?).to be_falsey
    end
  end

  describe '#deposit' do
    subject { create(:account, balance: 1) }

    it 'deposits money into an account' do
      subject.deposit(100)
      subject.deposit(200)
      expect(subject.balance).to eq(301)
    end
  end

  describe '#withdraw' do
    subject { create(:account, balance: 100) }

    it 'withdraws money from an account' do
      subject.withdraw(10)
      subject.withdraw(20)

      expect(subject.balance).to eq(70)
    end

    it 'raises an error on insufficient balance' do
      expect { subject.withdraw(300) }.to raise_error(WHOP::Errors::InsufficientBalance)
      expect(subject.balance).to eq(100)
    end
  end
end
