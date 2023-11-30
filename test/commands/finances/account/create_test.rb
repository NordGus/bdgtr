require "test_helper"

class Finances::Account::CreateTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "name presence" do
      command = ::Finances::Account::Create.new(name: nil)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return itself"
      assert_not_empty response.args.last[:name], "must return the expected errors"
      assert_includes response.args.last[:name], "can't be blank", "must return the expected error"
    end

    test "name length" do
      command = ::Finances::Account::Create.new(name: "one")
      expected_length = ::Finances::Account::Create::NAME_MINIMUM_LENGTH
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [command, {name: ["is too short (minimum is #{expected_length} characters)"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end
  end

  test "fails if the account already exists" do
    command = ::Finances::Account::Create.new(name: accounts(:personal).name)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal [accounts(:personal).name, ::Finances::Account::Create::NAME_NOT_UNIQUE_ERROR_MESSAGE],
                 response.args,
                 "must failed because there's an account with the same name in the system"
  end

  test "succeeds to create a new Account" do
    parameters = { name: "On the bounce" }
    command = ::Finances::Account::Create.new(**parameters)

    assert_difference "Account.count", 1, "must create an Account" do
      response = command.execute
      output = response.args.first.attributes.deep_symbolize_keys.slice(:name)

      assert response.success?, "must succeed"
      assert_equal parameters, output, "must create the Account with given parameters"
    end
  end
end
