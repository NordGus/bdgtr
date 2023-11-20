require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "should have incoming transactions" do
    account = accounts(:personal)
    assert_equal account.incoming_transactions.count, 1, "account doesn't have incoming transactions"
  end

  test "should have outgoing transactions" do
    account = accounts(:personal)
    assert_equal account.outgoing_transactions.count, 1, "account doesn't have incoming transactions"
  end

  test "name must be present" do
    account = Account.new
    assert_not account.valid?, "must be invalid"
    assert_includes account.errors.messages_for(:name), "can't be blank", "must validate account's name presence"
  end

  test "name must be at least 5 characters long" do
    account = Account.new
    assert_not account.valid?, "must be invalid"
    assert_includes account.errors.messages_for(:name), "is too short (minimum is 5 characters)", "must validate that account's name length"
  end
end
