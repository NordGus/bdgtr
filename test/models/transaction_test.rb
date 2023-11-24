require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "origin account presence" do
      parameters = {
        from: nil,
        to: accounts(:expense),
        amount: 420.69,
        issued_at: Date.today
      }
      transaction = Transaction.new(parameters)

      assert_not transaction.valid?, "must be invalid"
      assert_equal ["can't be blank"],
                   transaction.errors.messages_for(:from_id),
                   "must validate origin account is present"
    end

    test "destination account presence" do
      parameters = {
        from: accounts(:personal),
        to: nil,
        amount: 420.69,
        issued_at: Date.today
      }
      transaction = Transaction.new(parameters)

      assert_not transaction.valid?, "must be invalid"
      assert_equal ["can't be blank"],
                   transaction.errors.messages_for(:to_id),
                   "must validate destination account is present"
    end

    test "destination account must be other than origin account" do
      parameters = {
        from: accounts(:personal),
        to: accounts(:personal),
        amount: 420.69,
        issued_at: Date.today
      }
      transaction = Transaction.new(parameters)

      assert_not transaction.valid?, "must be invalid"
      assert_equal ["must be other than #{accounts(:personal).id}"],
                   transaction.errors.messages_for(:to_id),
                   "must validate destination account is other than origin account"
    end

    test "amount presence" do
      parameters = {
        from: accounts(:personal),
        to: accounts(:expense),
        amount: nil,
        issued_at: Date.today
      }
      transaction = Transaction.new(parameters)

      assert_not transaction.valid?, "must be invalid"
      assert_equal ["can't be blank"],
                   transaction.errors.messages_for(:amount),
                   "must validate amount is present"
    end

    test "amount must be greater than 0" do
      parameters = {
        from: accounts(:personal),
        to: accounts(:expense),
        amount: -420.69,
        issued_at: Date.today
      }
      transaction = Transaction.new(parameters)

      assert_not transaction.valid?, "must be invalid"
      assert_equal ["must be greater than 0"],
                   transaction.errors.messages_for(:amount),
                   "must validate that amount greater than 0"
    end

    test "issued_at presence" do
      parameters = {
        from: accounts(:personal),
        to: accounts(:expense),
        amount: 420.69,
        issued_at: nil
      }
      transaction = Transaction.new(parameters)

      assert_not transaction.valid?, "must be invalid"
      assert_equal ["can't be blank"],
                   transaction.errors.messages_for(:issued_at),
                   "must validate transaction's issued_at presence"
    end

    test "executed_at must be equal or later than issued_at when is present" do
      parameters = {
        from: accounts(:personal),
        to: accounts(:expense),
        amount: 420.69,
        issued_at: Date.today,
        executed_at: Date.yesterday
      }
      transaction = Transaction.new(parameters)

      assert_not transaction.valid?, "must be invalid"
      assert_equal ["must be greater than or equal to #{parameters[:issued_at]}"],
                   transaction.errors.messages_for(:executed_at),
                   "must validate transaction's executed_at is equal or later than issued_at"
    end
  end

  test "should have an origin Account" do
    assert_equal accounts(:personal).id,
                 transactions(:personal_expense_0).from.id,
                 "transaction doesn't come from expected transaction"
  end

  test "should have a destination Account" do
    assert_equal accounts(:expense).id,
                 transactions(:personal_expense_0).to.id,
                 "transaction doesn't go tp expected transaction"
  end
end
