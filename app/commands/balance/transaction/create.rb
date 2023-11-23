# frozen_string_literal: true

# Balance::Transaction::Create contains the logic to create a new Transaction in the system.
#
# Note: I'm aware that I'm duplicating behavior with ActiveRecord models, but my idea is to use this commands to
# eventually migrate the application to a different language or framework.
class Balance::Transaction::Create < Command::Base
  attribute :from_id, :integer
  attribute :to_id, :integer
  attribute :amount, :decimal, precision: 40, scale: 2
  attribute :issued_at, :date
  attribute :executed_at, :date

  validates :from_id, presence: true
  validates :to_id, comparison: { other_than: :from_id }
  validates :amount, comparison: { greater_than: 0 }
  validates :issued_at, presence: true
  validates :executed_at, comparison: { greater_than_or_equal_to: :issued_at }, if: ->(t) { t.executed_at.present? }

  def initialize(from_id:, to_id:, amount:, issued_at:, executed_at: nil)
    super()

    self.from_id = from_id
    self.to_id = to_id
    self.amount = amount
    self.issued_at = issued_at
    self.executed_at = executed_at
  end

  def execute
    valid?
      .and_then { find_origin_account }
      .and_then { |origin_account| find_destination_account(origin_account) }
      .and_then { |origin_account, destination_account| create_transaction(origin_account, destination_account) }
  end

  private

  def find_origin_account
    account = Account.find_by(id: self.from_id)

    return Railway::Response.success(account) if account
    Railway::Response.failure(self.from_id, "Origin Account not found")
  end

  def find_destination_account(origin_account)
    account = Account.find_by(id: self.to_id)

    return Railway::Response.success(origin_account, account) if account
    Railway::Response.failure(self.to_id, "Destination Account not found")
  end

  def create_transaction(origin_account, destination_account)
    transaction = Transaction.new(
      from: origin_account,
      to: destination_account,
      amount: self.amount,
      issued_at: self.issued_at,
      executed_at: self.executed_at
    )

    return Railway::Response.success(transaction) if transaction.save
    Railway::Response.failure(transaction)
  end
end
