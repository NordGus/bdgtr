require "test_helper"

class AccountTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "name present" do
      account = Account.new

      assert_not account.valid?, "must be invalid"
      assert_includes account.errors.messages_for(:name),
                      "can't be blank",
                      "must validate account's name presence"
    end

    test "name length" do
      account = Account.new

      assert_not account.valid?, "must be invalid"
      assert_includes account.errors.messages_for(:name),
                      "is too short (minimum is 5 characters)",
                      "must validate that account's name length"
    end
  end

  test "should have incoming transactions" do
    account = accounts(:personal)

    assert_equal 4, account.incoming_transactions.count, "account doesn't have incoming transactions"
  end

  test "should have outgoing transactions" do
    account = accounts(:personal)

    assert_equal 1, account.outgoing_transactions.count, "account doesn't have incoming transactions"
  end
end
