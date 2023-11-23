require "test_helper"

class Finances::Transaction::DeleteTest < ActiveSupport::TestCase

  class Validation < ActiveSupport::TestCase
    test "id presence" do
      command = ::Finances::Transaction::Delete.new(id: nil)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return an instance of itself"
      assert_equal({ id: ["can't be blank"] }, response.args.last, "must validate id's presence")
    end
  end

  test "fails when id doesn't belong to any Transaction" do
    bad_id = -42
    command = ::Finances::Transaction::Delete.new(id: bad_id)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal [bad_id, "Transaction not found"],
                 response.args,
                 "must failed because there's no Transaction with the given id"
  end

  test "succeeds" do
    transaction = Transaction.create(
      from: accounts(:personal),
      to: accounts(:expense),
      amount: 420.69,
      issued_at: Date.today,
      executed_at: Date.today
    )
    command = ::Finances::Transaction::Delete.new(id: transaction.id)

    assert_difference "Transaction.count", -1, "must delete an Transaction from the system" do
      response = command.execute

      assert response.success?, "must succeed"
      assert_equal transaction.id, response.args.first.id, "must delete the correct Transaction"
    end
  end
end
