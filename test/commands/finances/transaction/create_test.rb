require "test_helper"

class Finances::Transaction::CreateTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "from_id presence" do
      parameters = {
        from_id: nil,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return an instance of itself"
      assert_equal( {from_id: ["can't be blank"]},
                    response.args.last,
                   "must validate from_id's presence")
    end

    test "to_id presence" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: nil,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return an instance of itself"
      assert_equal({to_id: ["can't be blank"]},
                   response.args.last,
                   "must validate to_id's presence")
    end

    test "to_id must be other than from_id" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: accounts(:personal).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return an instance of itself"
      assert_equal({to_id: ["must be other than #{accounts(:personal).id}"]},
                   response.args.last,
                   "must validate to_id is other than from_id")
    end

    test "amount presence" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: nil,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return an instance of itself"
      assert_equal({amount: ["can't be blank"]},
                   response.args.last,
                   "must validate amount's presence")
    end

    test "amount must be greater than 0" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: -420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return an instance of itself"
      assert_equal({amount: ["must be greater than 0"]},
                   response.args.last,
                   "must validate that amount is greater than 0")
    end

    test "issued_at presence" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: nil
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return an instance of itself"
      assert_equal({issued_at: ["can't be blank"]},
                   response.args.last,
                   "must validate issued_at's presence")
    end

    test "executed_at greater than or equal to issued_at when executed_at is present" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.yesterday
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return an instance of itself"
      assert_equal({executed_at: ["must be greater than or equal to #{parameters[:issued_at].to_s}"]},
                   response.args.last,
                   "must validate that executed_at is greater than or equal to issued_at")
    end
  end

  class WithExecutedAt < ActiveSupport::TestCase
    test "fails when origin account doesn't exists" do
      parameters = {
        from_id: -42,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [parameters[:from_id], "Origin Account not found"],
                   response.args,
                   "must return from_id and error message"
    end

    test "fails when destination account doesn't exists" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: -42,
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [parameters[:to_id], "Destination Account not found"],
                   response.args,
                   "must return to_id and error message"
    end

    test "succeeds" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)

      assert_difference "Transaction.count", 1, "must create a new Transaction" do
        response = command.execute

        assert response.success?, "must succeed"
        assert_equal parameters[:from_id], response.args.first.from_id, "must have the passed from_id"
        assert_equal parameters[:to_id], response.args.first.to_id, "must have the passed to_id"
        assert_equal BigDecimal(parameters[:amount].to_s), response.args.first.amount, "must have the passed amount"
        assert_equal parameters[:issued_at], response.args.first.issued_at, "must have the passed issued_at"
        assert_equal parameters[:executed_at], response.args.first.executed_at, "must have the passed executed_at"
      end
    end
  end

  class WithoutExecutedAt < ActiveSupport::TestCase
    test "fails when origin account doesn't exists" do
      parameters = {
        from_id: -42,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [parameters[:from_id], "Origin Account not found"],
                   response.args,
                   "must return from_id and error message"
    end

    test "fails when destination account doesn't exists" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: -42,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [parameters[:to_id], "Destination Account not found"],
                   response.args,
                   "must return to_id and error message"
    end

    test "succeeds" do
      parameters = {
        from_id: accounts(:personal).id,
        to_id: accounts(:expense).id,
        amount: 420.69,
        issued_at: Date.today
      }
      command = ::Finances::Transaction::Create.new(**parameters)

      assert_difference "Transaction.count", 1, "must create a new Transaction in the system" do
        response = command.execute

        assert response.success?, "must succeed"
        assert_equal parameters[:from_id], response.args.first.from_id, "must have the passed from_id"
        assert_equal parameters[:to_id], response.args.first.to_id, "must have the passed to_id"
        assert_equal BigDecimal(parameters[:amount].to_s), response.args.first.amount, "must have the passed amount"
        assert_equal parameters[:issued_at], response.args.first.issued_at, "must have the passed issued_at"
        assert_nil response.args.first.executed_at, "executed_at must be nil"
      end
    end
  end
end
