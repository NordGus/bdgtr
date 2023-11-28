require "test_helper"

class Finances::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:additional)
  end

  class IndexAction < ActionDispatch::IntegrationTest
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

  class NewAction < ActionDispatch::IntegrationTest
    test "should get new" do
      get new_finances_account_url

      assert_response :success
    end

    test "must return a turbo stream response" do
      get new_finances_account_url

      assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
    end

    class ViewTest < ActionDispatch::IntegrationTest
      test "should return a turbo-stream with action update" do
        get new_finances_account_url

        assert_select "turbo-stream:match('action', ?)", "update", 1
      end

      test "should return a turbo-stream with target account" do
        get new_finances_account_url

        assert_select "turbo-stream:match('target', ?)", "account", 1
      end

      test "should return a turbo-stream with with a template that contains the account details partial" do
        get new_finances_account_url

        # assert_equal "", response.body

        assert_select "turbo-stream template", 1 do
          assert_select "form:match('action', ?)", finances_accounts_path, 1
          assert_select "form:match('method', ?)", "post", 1

          assert_select "form", 1 do
            assert_select "input", 2

            assert_select "input:match('id', ?)", "finances_account_form_name", 1
            assert_select "input:match('type', ?)", "text", 1

            assert_select "input:match('class', ?)", "hidden", 1
            assert_select "input:match('type', ?)", "submit", 1
          end
        end
      end
    end
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
