require "test_helper"

class Finances::Account::DeleteTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "validates the presence of the id parameter" do
      command = ::Finances::Account::Delete.new(id: nil)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [command, {id: ["can't be blank"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end
  end

  test "fails when id doesn't belong to any Account" do
    bad_id = -42
    command = ::Finances::Account::Delete.new(id: bad_id)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal [bad_id, "Account not found"],
                 response.args,
                 "must failed because there's no Account with the given id"
  end

  test "succeeds to delete the Account" do
    account = Account.create(name: "On the bounce")
    command = ::Finances::Account::Delete.new(id: account.id)

    assert_difference "Account.count", -1, "must delete an Account from the system" do
      response = command.execute

      assert response.success?, "must succeed"
      assert_equal account.id, response.args.first.id, "must delete the correct Account"
    end
  end
end
