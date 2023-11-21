require "test_helper"

class Finances::Account::CreateTest < ActiveSupport::TestCase
  test "validates the presence of the name parameter" do
    command = ::Finances::Account::Create.new(name: "")
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal response.args.first, command, "must return an instance of itself"
    assert_equal response.args.last, {name: ["can't be blank"]}, "must validate name's presence"
  end

  test "fails if the account already exists" do
    command = ::Finances::Account::Create.new(name: accounts(:personal).name)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal response.args,
                 [accounts(:personal).name, "Account already exists"],
                 "must failed because there's an account with the same name in the system"
  end

  test "succeeds to create a new Account" do
    account_name = "On the bounce"
    command = ::Finances::Account::Create.new(name: account_name)
    response = nil

    assert_difference "Account.count", 1, "must create an Account" do
      response = command.execute
    end

    assert response&.success?, "must succeed"
    assert_equal response&.args&.first&.name, account_name, "must create the new Account with the correct name"
  end
end
