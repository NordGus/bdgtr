require "test_helper"

class Finances::Account::CreateTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "validates the presence of the name parameter" do
      command = ::Finances::Account::Create.new(name: "")
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [command, {name: ["can't be blank"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end
  end

  test "fails if the account already exists" do
    command = ::Finances::Account::Create.new(name: accounts(:personal).name)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal [accounts(:personal).name, "Account already exists"],
                 response.args,
                 "must failed because there's an account with the same name in the system"
  end

  test "succeeds to create a new Account" do
    parameters = {
      name: "On the bounce"
    }
    command = ::Finances::Account::Create.new(**parameters)

    assert_difference "Account.count", 1, "must create an Account" do
      response = command.execute
      output = response.args.first.attributes.deep_symbolize_keys.slice(:name)

      assert response.success?, "must succeed"
      assert_equal parameters, output, "must create the Account with given parameters"
    end
  end
end
