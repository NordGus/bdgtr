# frozen_string_literal: true

# Finances::Account::Create contains the logic to create a new Account in the system.
# Note: I'm aware that I'm duplicating behavior with ActiveRecord models, but my idea
# is to use this commands to eventually migrate the application to a different language
# or framework.
class Finances::Account::Create < Command::Base
  attr_accessor :name

  validates :name, presence: true

  def initialize(name:)
    super()

    self.name = name
  end

  def execute
    valid?
      .and_then { check_if_already_exists }
      .and_then { create_new_account }
  end

  private

  def check_if_already_exists
    return Railway::Response.failure("Account (#{self.name}) already exists.") if Account.find_by_name(self.name)
    Railway::Response.success(self)
  end

  def create_new_account
    account = Account.new(name: self.name)

    return Railway::Response.success(account) if account.save
    Railway::Response.failure(account, account.errors.messages)
  end
end
