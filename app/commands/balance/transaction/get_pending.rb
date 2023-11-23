# frozen_string_literal: true

# Balance::Transaction::GetPending contains to retrieve all pending transactions in the system; a pending transaction
# is a transaction that doesn't have an executed_at date.
#
# Note: I'm aware that I'm duplicating behavior with ActiveRecord models, but my idea is to use this commands to
# eventually migrate the application to a different language or framework.
class Balance::Transaction::GetPending < Command::Base
  attribute :for_id, :integer
  attribute :starting_at, :date
  attribute :ending_at, :date

  validates :starting_at, presence: true
  validates :ending_at, comparison: { greater_than_or_equal_to: :starting_at }, if: ->(cmd) { cmd.starting_at.present? }

  def initialize(for_id: nil, starting_at:, ending_at:)
    super()

    self.for_id = for_id
    self.starting_at = starting_at
    self.ending_at = ending_at
  end

  def execute
    valid?
      .and_then { build_scope }
      .and_then { |scope_container| find_for_account_if_passed(scope_container) }
      .and_then { |scope_container, for_account| filter_by_for_account(scope_container, for_account) }
  end

  private

  def build_scope
    scope = Transaction
              .includes(:from, :to)
              .where(executed_at: nil, issued_at: self.starting_at..self.ending_at)
              .order(issued_at: :desc)

    Railway::Response.success(ScopeContainer.new(scope))
  end

  def find_for_account_if_passed(scope_container)
    return Railway::Response.success(scope_container) unless self.for_id.present?

    account = Account.find_by(id: self.for_id)

    return Railway::Response.success(scope_container, account) if account
    Railway::Response.failure(self.for_id, "Account not found")
  end

  def filter_by_for_account(scope_container, for_account)
    return Railway::Response.success(scope_container) unless for_account.present?

    Railway::Response.success(ScopeContainer.new(
      scope_container
        .scope
        .where(from: for_account)
        .or(scope_container.scope.where(to: for_account))
    ))
  end
end
