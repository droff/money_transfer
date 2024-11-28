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
end
