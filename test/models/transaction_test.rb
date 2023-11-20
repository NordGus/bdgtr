require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "should have an origin Account" do
    transaction = transactions(:personal_expense)
    expected_origin_account = accounts(:personal)

    assert_equal transaction.from.id, expected_origin_account.id, "transaction doesn't come from expected transaction"
  end

  test "should have a destination Account" do
    transaction = transactions(:personal_expense)
    expected_destination_account = accounts(:expense)

    assert_equal transaction.to.id, expected_destination_account.id, "transaction doesn't go tp expected transaction"
  end

  test "origin account must be other than destination account" do
    account = accounts(:personal)
    transaction = Transaction.new(from: account, to: account)

    assert_not transaction.valid?, "must be invalid"
    assert_includes transaction.errors.messages_for(:from_id), "must be other than #{account.id}", "must validate transaction's destination account must be other than its origin account"
  end

  test "destination account must be other than origin account" do
    account = accounts(:personal)
    transaction = Transaction.new(from: account, to: account)

    assert_not transaction.valid?, "must be invalid"
    assert_includes transaction.errors.messages_for(:to_id), "must be other than #{account.id}", "must validate transaction's origin account must be other than its destination account"
  end

  test "amount must be present" do
    transaction = Transaction.new

    assert_not transaction.valid?, "must be invalid"
    assert_includes transaction.errors.messages_for(:amount), "can't be blank", "must validate transaction's amount presence"
  end

  test "amount must be greater than 0" do
    transaction = Transaction.new(amount: -420.69)

    assert_not transaction.valid?, "must be invalid"
    assert_includes transaction.errors.messages_for(:amount), "must be greater than 0", "must validate that transaction's amount value"
  end

  test "issued_at must be present" do
    transaction = Transaction.new

    assert_not transaction.valid?, "must be invalid"
    assert_includes transaction.errors.messages_for(:issued_at), "can't be blank", "must validate transaction's issued_at presence"
  end

  test "executed_at may not be present" do
    transaction = Transaction.new(from: accounts(:personal), to: accounts(:expense), amount: 420.69, issued_at: Date.today)

    assert transaction.valid?, "must be valid"
  end

  test "when executed_at is present, must be equal or later than issued_at" do
    transaction = Transaction.new(from: accounts(:personal), to: accounts(:expense), amount: 420.69, issued_at: Date.today, executed_at: Date.yesterday)

    assert_not transaction.valid?, "must be invalid"
    assert_includes transaction.errors.messages_for(:executed_at), "must be greater than or equal to #{Date.today.to_s}", "must validate transaction's executed_at is equal or later than issued_at"
  end
end
