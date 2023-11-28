require "test_helper"

class Finances::AccountsController::CreateActionTest < ActionDispatch::IntegrationTest
  test "should create an account" do
    assert_difference "Account.count", 1 do
      post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }
    end

    assert_response :success
  end

  test "must return a turbo stream response" do
    post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  class ViewTest < ActionDispatch::IntegrationTest
    class AccountTurboFrame < ViewTest
      test "should return a turbo-stream with action update" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream:match('action', ?)", "update", 1
      end

      test "should return a turbo-stream with target account" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream:match('target', ?)", "account", 1
      end

      test "should return a turbo-stream with with a template that contains the account details partial" do
        post finances_accounts_path(@account), params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream template", 1 do
          assert_select "form:match('action', ?)", finances_account_path(@account), 1
          assert_select "form:match('method', ?)", "post", 1

          assert_select "form", 1 do
            assert_select "input", 3

            assert_select "input[type='hidden'][name='_method'][value='patch']", 1

            assert_select "input:match('id', ?)", "finances_account_form_name", 1
            assert_select "input:match('type', ?)", "text", 1
            assert_select "input:match('value', ?)", @account.name, 1

            assert_select "input:match('class', ?)", "hidden", 1
            assert_select "input:match('type', ?)", "submit", 1
          end
        end
      end
    end
  end
end
