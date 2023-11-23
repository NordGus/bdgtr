# frozen_string_literal: true

# Finances::Transaction::Update contains the logic to update an existing Transaction in the system.
#
# Note: I'm aware that I'm duplicating behavior with ActiveRecord models, but my idea is to use this commands to
# eventually migrate the application to a different language or framework.
class Finances::Transaction::Update < Command::Base
  attribute :id, :integer
  attribute :from_id, :integer
  attribute :to_id, :integer
  attribute :amount, :decimal, precision: 40, scale: 2
  attribute :issued_at, :date
  attribute :executed_at, :date

  validates :id, presence: true
  validates :from_id, presence: true
  validates :to_id, comparison: { other_than: :from_id }
  validates :amount, comparison: { greater_than: 0 }
  validates :issued_at, presence: true
  validates :executed_at, comparison: { greater_than_or_equal_to: :issued_at }, if: ->(t) { t.executed_at.present? }

  def initialize(id:, from_id:, to_id:, amount:, issued_at:, executed_at: nil)
    super()

    self.id = id
    self.from_id = from_id
    self.to_id = to_id
    self.amount = amount
    self.issued_at = issued_at
    self.executed_at = executed_at
  end

  def execute
    valid?
      .and_then { find_transaction }
      .and_then { |transaction| find_origin_account(transaction) }
      .and_then { |transaction, origin_account| find_destination_account(transaction, origin_account) }
      .and_then { |transaction, origin_account, destination_account| update_transaction(transaction, origin_account, destination_account) }
  end

  private

  def find_transaction
    transaction = Transaction.find_by(id: self.id)

    return Railway::Response.success(transaction) if transaction
    Railway::Response.failure(self.id, "Transaction not found")
  end

  def find_origin_account(transaction)
    account = Account.find_by(id: self.from_id)

    return Railway::Response.success(transaction, account) if account
    Railway::Response.failure(self.from_id, "Origin Account not found")
  end

  def find_destination_account(transaction, origin_account)
    account = Account.find_by(id: self.to_id)

    return Railway::Response.success(transaction, origin_account, account) if account
    Railway::Response.failure(self.to_id, "Destination Account not found")
  end

  def update_transaction(transaction, origin_account, destination_account)
    parameters = {
      from: origin_account,
      to: destination_account,
      amount: self.amount,
      issued_at: self.issued_at,
      executed_at: self.executed_at
    }

    return Railway::Response.success(transaction) if transaction.update(parameters)
    Railway::Response.failure(transaction)
  end
end
