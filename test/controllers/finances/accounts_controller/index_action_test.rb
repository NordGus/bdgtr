require "test_helper"

class Finances::AccountsController::IndexActionTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get finances_accounts_url

    assert_response :success
  end

  test "must return a turbo stream response" do
    get finances_accounts_url

    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  class ViewTest < ActionDispatch::IntegrationTest
    test "should return a turbo-stream with action append" do
      get finances_accounts_url

      assert_select "turbo-stream:match('action', ?)", "append", 1
    end

    test "should return a turbo-stream with target accounts" do
      get finances_accounts_url

      assert_select "turbo-stream:match('target', ?)", "accounts", 1
    end

    test "should return a turbo-stream with with a template that contains all accounts in the system" do
      get finances_accounts_url

      assert_select "turbo-stream template", 1 do
        assert_select "a", accounts.count
        assert_select "a:match('data-action', ?)", "click->finances#displayAccount", accounts.count
        assert_select "a:match('data-turbo-frame', ?)", "account", accounts.count

        accounts.each do |account|
          assert_select "a:match('id', ?)", dom_id(account), 1
          assert_select "a:match('href', ?)", finances_account_path(account), 1
        end
      end
    end
  end
end
