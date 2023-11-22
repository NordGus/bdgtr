require "test_helper"

class Finances::Transaction::UpdateTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "id presence" do
      parameters = {
        id: nil,
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args.first, command, "must return an instance of itself"
      assert_equal response.args.last,
                   {id: ["can't be blank"]},
                   "must validate id's presence"
    end

    test "from_id presence" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: nil,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args.first, command, "must return an instance of itself"
      assert_equal response.args.last,
                   {from_id: ["can't be blank"]},
                   "must validate from_id's presence"
    end

    test "to_id presence" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: nil,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args.first, command, "must return an instance of itself"
      assert_equal response.args.last,
                   {to_id: ["can't be blank"]},
                   "must validate to_id's presence"
    end

    test "to_id must be other than from_id" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: accounts(:personal).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args.first, command, "must return an instance of itself"
      assert_equal response.args.last,
                   {to_id: ["must be other than #{accounts(:personal).id}"]},
                   "must validate to_id is other than from_id"
    end

    test "amount presence" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: nil,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args.first, command, "must return an instance of itself"
      assert_equal response.args.last,
                   {amount: ["can't be blank"]},
                   "must validate amount's presence"
    end

    test "amount must be greater than 0" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: -420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args.first, command, "must return an instance of itself"
      assert_equal response.args.last,
                   {amount: ["must be greater than 0"]},
                   "must validate that amount is greater than 0"
    end

    test "issued_at presence" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: nil
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args.first, command, "must return an instance of itself"
      assert_equal response.args.last,
                   {issued_at: ["can't be blank"]},
                   "must validate issued_at's presence"
    end

    test "executed_at greater than or equal to issued_at when executed_at is present" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.yesterday
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args.first, command, "must return an instance of itself"
      assert_equal response.args.last,
                   {executed_at: ["must be greater than or equal to #{parameters[:issued_at].to_s}"]},
                   "must validate that executed_at is greater than or equal to issued_at"
    end
  end

  class WithExecutedAt < ActiveSupport::TestCase
    test "fails when transactions doesn't exists" do
      parameters = {
        id: -42,
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args,
                   [parameters[:id], "Transaction not found"],
                   "must return id and error message"
    end

    test "fails when origin account doesn't exists" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: -42,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args,
                   [parameters[:from_id], "Origin Account not found"],
                   "must return from_id and error message"
   end

    test "fails when destination account doesn't exists" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: -42,
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args,
                   [parameters[:to_id], "Destination Account not found"],
                   "must return to_id and error message"
    end

    test "succeeds" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert response.success?, "must succeed"
      assert_equal response.args.first.id, parameters[:id], "must update the right Transaction"
      assert_equal response.args.first.from_id, parameters[:from_id], "must have the passed from_id"
      assert_equal response.args.first.to_id, parameters[:to_id], "must have the passed to_id"
      assert_equal response.args.first.amount, BigDecimal(parameters[:amount].to_s), "must have the passed amount"
      assert_equal response.args.first.issued_at, parameters[:issued_at], "must have the passed issued_at"
      assert_equal response.args.first.executed_at, parameters[:executed_at], "must have the passed executed_at"
    end
  end

  class WithoutExecutedAt < ActiveSupport::TestCase
    test "fails when transactions doesn't exists" do
      parameters = {
        id: -42,
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args,
                   [parameters[:id], "Transaction not found"],
                   "must return id and error message"
    end

    test "fails when origin account doesn't exists" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: -42,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args,
                   [parameters[:from_id], "Origin Account not found"],
                   "must return from_id and error message"
    end

    test "fails when destination account doesn't exists" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: -42,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal response.args,
                   [parameters[:to_id], "Destination Account not found"],
                   "must return to_id and error message"
    end

    test "succeeds" do
      parameters = {
        id: transactions(:personal_expense).id,
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Update.new(**parameters)
      response = command.execute

      assert response.success?, "must succeed"
      assert_equal response.args.first.id, parameters[:id], "must update the right Transaction"
      assert_equal response.args.first.from_id, parameters[:from_id], "must have the passed from_id"
      assert_equal response.args.first.to_id, parameters[:to_id], "must have the passed to_id"
      assert_equal response.args.first.amount, BigDecimal(parameters[:amount].to_s), "must have the passed amount"
      assert_equal response.args.first.issued_at, parameters[:issued_at], "must have the passed issued_at"
      assert_nil response.args.first.executed_at, "executed_at must be nil"
    end
  end
end
