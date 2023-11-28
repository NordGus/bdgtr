require "test_helper"

class Finances::AccountsController::NewActionTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_finances_account_path

    assert_response :success
  end

  test "must return a turbo stream response" do
    get new_finances_account_path

    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  class ViewTest < ActionDispatch::IntegrationTest
    test "should return a turbo-stream with action update" do
      get new_finances_account_path

      assert_select "turbo-stream:match('action', ?)", "update", 1
    end

    test "should return a turbo-stream with target account" do
      get new_finances_account_path

      assert_select "turbo-stream:match('target', ?)", "account", 1
    end

    test "should return a turbo-stream with with a template that contains the account details partial" do
      get new_finances_account_path

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
