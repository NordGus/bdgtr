require "test_helper"

class Finances::Account::UpdateTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "validates the presence of the id parameter" do
      parameters = {
        id: nil,
        name: "On the bounce"
      }
      command = ::Finances::Account::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [command, {id: ["can't be blank"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end

    test "validates the presence of the name parameter" do
      parameters = {
        id: -42,
        name: nil
      }
      command = ::Finances::Account::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [command, {name: ["can't be blank"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end
  end

  test "fails when id doesn't belong to any Account" do
    parameters = {
      id: -42,
      name: "On the bounce"
    }
    command = ::Finances::Account::Update.new(**parameters)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal [parameters[:id], "Account not found"],
                 response.args,
                 "must failed because there's no Account with the given id"
  end

  test "fails if an account already exists with the given name" do
    parameters = {
      id: accounts(:personal).id,
      name: accounts(:expense).name
    }
    command = ::Finances::Account::Update.new(**parameters)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal [parameters[:name], "Account already exists"],
                 response.args,
                 "must failed because there's and account with the same name in the system"
  end

  test "succeeds to update the Account" do
    parameters = {
      id: accounts(:personal).id,
      name: "On the bounce"
    }
    command = ::Finances::Account::Update.new(**parameters)
    response = command.execute
    output = response.args.first.attributes.deep_symbolize_keys.slice(:id, :name)

    assert response.success?, "must succeed"
    assert_equal parameters, output, "must update the Account with given parameters"
  end
end
