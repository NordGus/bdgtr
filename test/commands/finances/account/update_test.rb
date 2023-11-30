require "test_helper"

class Finances::Account::UpdateTest < ActiveSupport::TestCase
  class Validation < ActiveSupport::TestCase
    test "id presence" do
      parameters = { id: nil, name: "On the bounce" }
      command = ::Finances::Account::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal [command, {id: ["can't be blank"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end

    test "name presence" do
      parameters = { id: accounts(:personal).id, name: nil }
      command = ::Finances::Account::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return itself"
      assert_includes response.args.last[:name],
                      "can't be blank",
                      "must return itself and the expected errors hash"
    end

    test "name length" do
      parameters = { id: accounts(:personal).id, name: "Q*" }
      expected_length = ::Finances::Account::Create::NAME_MINIMUM_LENGTH
      command = ::Finances::Account::Update.new(**parameters)
      response = command.execute

      assert_not response.success?, "must not succeed"
      assert_equal command, response.args.first, "must return itself"
      assert_equal [command, {name: ["is too short (minimum is #{expected_length} characters)"]}],
                   response.args,
                   "must return itself and the expected errors hash"
    end
  end

  test "fails when id doesn't belong to any Account" do
    parameters = { id: -42, name: "On the bounce" }
    command = ::Finances::Account::Update.new(**parameters)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal [parameters[:id], ::Finances::Account::Update::NOT_FOUND_ERROR_MESSAGE],
                 response.args,
                 "must failed because there's no Account with the given id"
  end

  test "fails if an account already exists with the given name" do
    parameters = { id: accounts(:personal).id, name: accounts(:expense).name }
    command = ::Finances::Account::Update.new(**parameters)
    response = command.execute

    assert_not response.success?, "must not succeed"
    assert_equal [parameters[:name], ::Finances::Account::Update::NAME_NOT_UNIQUE_ERROR_MESSAGE],
                 response.args,
                 "must failed because there's and account with the same name in the system"
  end

  test "doesn't fails if the account's name doesn't changes" do
    parameters = { id: accounts(:personal).id, name: accounts(:personal).name }
    command = ::Finances::Account::Update.new(**parameters)
    response = command.execute

    assert response.success?, "must succeed"
  end

  test "succeeds to update the Account" do
    parameters = { id: accounts(:personal).id, name: "On the bounce" }
    command = ::Finances::Account::Update.new(**parameters)
    response = command.execute
    output = response.args.first.attributes.deep_symbolize_keys.slice(:id, :name)

    assert response.success?, "must succeed"
    assert_equal parameters, output, "must update the Account with given parameters"
  end
end
