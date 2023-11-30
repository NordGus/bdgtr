require "test_helper"

class Finances::Account::GetAllTest < ActiveSupport::TestCase
  test "returns all accounts in the system" do
    command = ::Finances::Account::GetAll.new
    response = command.execute

    assert response.success?, "must succeed"
    assert_equal 3, response.args.first.scope.count, "must return the expected number of Accounts"
  end
end
