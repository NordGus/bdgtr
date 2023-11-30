# frozen_string_literal: true

# Finances::Account::Update contains the logic to update an existing Account in the system.
#
# Note: I'm aware that I'm duplicating behavior with ActiveRecord models, but my idea is to use this commands to
# eventually migrate the application to a different language or framework.
class Finances::Account::Update < Command::Base
  NAME_MINIMUM_LENGTH = ::Account::MINIMUM_NAME_LENGTH.freeze

  NOT_FOUND_ERROR_MESSAGE = "Account not found".freeze
  NAME_NOT_UNIQUE_ERROR_MESSAGE = "Account already exists".freeze

  attribute :id, :integer
  attribute :name, :string

  validates :id, presence: true
  validates :name, presence: true, length: { minimum: NAME_MINIMUM_LENGTH }

  def initialize(id:, name:)
    super()

    self.id = id
    self.name = name
  end

  def execute
    valid?
      .and_then { find_account }
      .and_then { |account| check_if_already_exists(account) }
      .and_then { |account| update_account(account) }
  end

  private

  def find_account
    account = Account.find_by(id: self.id)

    return Railway::Response.success(account) if account
    Railway::Response.failure(self.id, NOT_FOUND_ERROR_MESSAGE)
  end

  def check_if_already_exists(account)
    duplicate_account = Account.find_by_name(self.name)

    return Railway::Response.success(account) unless duplicate_account
    return Railway::Response.failure(self.name, NAME_NOT_UNIQUE_ERROR_MESSAGE) unless duplicate_account.id == account.id
    Railway::Response.success(account)
  end

  def update_account(account)
    return Railway::Response.success(account) if account.update(name: self.name)
    Railway::Response.failure(account, account.errors.messages)
  end
end
