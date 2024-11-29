module WHOP::Errors
  class BaseError < StandardError; end
  class InsufficientBalance < BaseError; end
  class InvalidToken < BaseError; end
  class ValidationError < BaseError; end
end
