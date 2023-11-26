# frozen_string_literal: true

# Finances::Account::Delete contains the logic to delete an existing Account from the system.
#
# Note: I'm aware that I'm duplicating behavior with ActiveRecord models, but my idea is to use this commands to
# eventually migrate the application to a different language or framework.
class Finances::Account::Delete < Command::Base
  NOT_FOUND_ERROR_MESSAGE = "Account not found".freeze

  attribute :id, :integer

  validates :id, presence: true

  def initialize(id:)
    super()

    self.id = id
  end

  def execute
    valid?
      .and_then { find_account }
      .and_then { |account| delete_account(account) }
  end

  private

  def find_account
    account = Account.find_by(id: self.id)

    return Railway::Response.success(account) if account
    Railway::Response.failure(self.id, NOT_FOUND_ERROR_MESSAGE)
  end

  def delete_account(account)
    return Railway::Response.success(account) if account.destroy
    Railway::Response.failure(account, account.errors.messages)
  end
end
