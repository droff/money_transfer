class WHOP::Bank
  API_URL = 'https://whop-bank-interview-api.whop.workers.dev'.freeze
  HEADERS = {
     content_type: 'application/json'
  }.freeze

  class << self
    def client
      new
    end
  end

  def deposit(whop_bank_token, amount)
    payload = { whop_bank_token: whop_bank_token, amount: amount }
    client['/deposit'].post(payload.to_json)
    true
  rescue
    false
  end

  def withdraw(whop_bank_token, amount)
    payload = { whop_bank_token: whop_bank_token, amount: amount }
    client['/withdraw'].post(payload.to_json)
    true
  rescue
    false
  end

  private

  def client
    @client ||= RestClient::Resource.new(API_URL, headers: HEADERS)
  end
end
