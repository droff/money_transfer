require 'rails_helper'

describe WHOP::Client do
  subject { described_class.init }

  let(:whop_bank_token) { '0XZ1JHd6ICZpxWY2JCLwADMxojI5FGblRmIsICMwEjI6ICduV3btFmIsICdpN3bwVGZiojIlBXe0Jye' }
  let(:invalid_token) { '9V2csFmZ6ICZpxWY2JCLwATN6ISehxWZkJCLiADMxIiOiQnb19WbhJCLicXYyRGa0l2diojIlBXe0Jye' }
  let(:amount) { 100 }
  let(:body) { { whop_bank_token: whop_bank_token, amount: amount }.to_json }
  let(:invalid_body) { { whop_bank_token: invalid_token, amount: 1 }.to_json }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe '#deposit' do
    let(:uri) { "#{described_class::API_URL}/deposit" }

    it 'returns true if response was successful' do
      stub_request(:post, uri).with(body: body, headers: headers).to_return(status: 200)

      result = subject.deposit(whop_bank_token, amount)
      expect(result).to be_truthy
    end

    it 'return false if response was unsuccessful' do
      stub_request(:post, uri).with(body: invalid_body, headers: headers).to_return(status: 400)

      result = subject.deposit(invalid_token, 1)
      expect(result).to be_falsey
    end
  end

  describe '#withdraw' do
    let(:uri) { "#{described_class::API_URL}/withdraw" }

    it 'returns true if response was successful' do
      stub_request(:post, uri).with(body: body, headers: headers).to_return(status: 200)

      result = subject.withdraw(whop_bank_token, amount)
      expect(result).to be_truthy
    end

    it 'return false if response was unsuccessful' do
      stub_request(:post, uri).with(body: invalid_body, headers: headers).to_return(status: 400)

      result = subject.withdraw(invalid_token, 1)
      expect(result).to be_falsey
    end
  end
end
