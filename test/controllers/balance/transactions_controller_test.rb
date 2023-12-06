require "test_helper"

class Balance::TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get balance_transactions_index_url
    assert_response :success
  end

  test "should get new" do
    get balance_transactions_new_url
    assert_response :success
  end

  test "should get create" do
    get balance_transactions_create_url
    assert_response :success
  end

  test "should get show" do
    get balance_transactions_show_url
    assert_response :success
  end

  test "should get update" do
    get balance_transactions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get balance_transactions_destroy_url
    assert_response :success
  end
end
