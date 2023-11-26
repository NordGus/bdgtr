require "test_helper"

class Finances::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:additional)
  end

  test "should get index" do
    get finances_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_finances_account_url
    assert_response :success
  end

  test "should create finances_account" do
    assert_difference("Account.count", 1) do
      post finances_accounts_url, params: { finances_account_form: { name: "On the bounce" } }
    end

    assert_redirected_to finances_accounts_path
  end

  test "should show finances_account" do
    get finances_account_url(@account)
    assert_response :success
  end

  test "should update account" do
    patch finances_account_url(@account), params: { finances_account_form: { name: "On the bounce" } }
    assert_redirected_to finances_accounts_path
  end

  test "should destroy finances_account" do
    assert_difference("Account.count", -1) do
      delete finances_account_url(@account)
    end

    assert_redirected_to finances_accounts_url
  end
end
