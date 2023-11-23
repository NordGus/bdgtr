# frozen_string_literal: true

# Finances::Transaction::Delete contains the logic to delete an existing Transaction from the system.
#
# Note: I'm aware that I'm duplicating behavior with ActiveRecord models, but my idea is to use this commands to
# eventually migrate the application to a different language or framework.
class Finances::Transaction::Delete < Command::Base
  attr_accessor :id, :integer

  validates :id, presence: true

  def initialize(id:)
    super()

    self.id = id
  end

  def execute
    valid?
      .and_then { find_transaction }
      .and_then { |transaction| delete_transaction(transaction) }
  end

  private

  def find_transaction
    transaction = Transaction.find_by(id: self.id)

    return Railway::Response.success(transaction) if transaction
    Railway::Response.failure(self.id, "Transaction not found")
  end

  def delete_transaction(transaction)
    return Railway::Response.success(transaction) if transaction.destroy
    Railway::Response.failure(transaction, transaction.errors.messages)
  end
end
