require "test_helper"

class Balance::Transaction::GetPendingTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "starting_at presence" do
      parameters = { starting_at: nil, ending_at: Date.tomorrow }
      command = ::Balance::Transaction::GetPending.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [command, {starting_at: ["can't be blank"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end

    test "ending_at presence" do
      parameters = { starting_at: Date.today, ending_at: nil }
      command = ::Balance::Transaction::GetPending.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [command, {ending_at: ["can't be blank"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end

    test "ending_at must be greater than or equal to starting_at" do
      parameters = { starting_at: Date.today, ending_at: Date.yesterday }
      command = ::Balance::Transaction::GetPending.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [command, {ending_at: ["must be greater than or equal to #{parameters[:starting_at].to_s}"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end
  end

  class WithoutForId < ActiveSupport::TestCase
    test "returns the transactions with issued_at between starting_at and ending_at" do
      parameters = { starting_at: Date.new(2023, 11, 1), ending_at: Date.new(2023, 12, 1) }
      command = ::Balance::Transaction::GetPending.new(**parameters)
      response = command.execute

      assert response.success?, "must succeed"
      assert_equal 3, response.args.first.scope.count, "must return the expected number of Transactions"
    end
  end

  class WithForId < ActiveSupport::TestCase
    test "fails when for account doesn't exists" do
      parameters = {
        for_id: -42,
        starting_at: Date.new(2023, 11, 1),
        ending_at: Date.new(2023, 12, 1)
      }
      command = ::Balance::Transaction::GetPending.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [parameters[:for_id], "Account not found"],
                   response.args,
                   "must return for_id and error message"
    end

    test "returns the transactions with issued_at between starting_at and ending_at for the account with for_id" do
      parameters = {
        for_id: accounts(:personal).id,
        starting_at: Date.new(2023, 11, 1),
        ending_at: Date.new(2023, 12, 1)
      }
      command = ::Balance::Transaction::GetPending.new(**parameters)
      response = command.execute

      assert response.success?, "must succeed"
      assert_equal 2, response.args.first.scope.count, "must return the expected number of Transactions"
    end
  end
end
