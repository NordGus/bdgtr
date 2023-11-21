require "test_helper"

class Finances::Account::UpdateTest < ActiveSupport::TestCase
  test "validates the presence of the id parameter" do
    command = ::Finances::Account::Update.new(id: nil, name: "")
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal response.args.first, command, "must return an instance of itself"
    assert_equal response.args.last[:id], ["can't be blank"], "must validate id's presence"
  end

  test "validates the presence of the name parameter" do
    command = ::Finances::Account::Update.new(id: nil, name: "")
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal response.args.first, command, "must return an instance of itself"
    assert_equal response.args.last[:name], ["can't be blank"], "must validate name's presence"
  end

  test "fails when id doesn't belong to any Account" do
    account_name = "On the bounce"
    command = ::Finances::Account::Update.new(id: "bad_id", name: account_name)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal response.args,
                 ["bad_id", "Account not found"],
                 "must failed because there's no Account with the given id"
  end

  test "fails if an account already exists with the given name" do
    command = ::Finances::Account::Update.new(id: accounts(:personal).id, name: accounts(:expense).name)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal response.args,
                 [accounts(:expense).name, "Account already exists"],
                 "must failed because there's and account with the same name in the system"
  end

  test "succeeds to update the Account" do
    account_name = "On the bounce"
    command = ::Finances::Account::Update.new(id: accounts(:personal).id, name: account_name)
    response = command.execute

    assert response.success?, "must succeed"
    assert_equal response.args.first.id, accounts(:personal).id, "must update the correct Account"
    assert_equal response.args.first.name, account_name, "must update the Account's name"
  end
end
