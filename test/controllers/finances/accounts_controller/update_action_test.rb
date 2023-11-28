require "test_helper"

class Finances::AccountsController::UpdateActionTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:additional)
  end

  test "should show account" do
    patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

    assert_response :success
  end

  test "must return a turbo stream response" do
    patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  class ViewTest < ActionDispatch::IntegrationTest
    setup do
      @account = accounts(:additional)
    end

    class AccountTurboFrame < ViewTest
      test "should return a turbo-stream with action update" do
        patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='update'][target='account']", 1
      end

      test "turbo-stream with must contain a template with the account details partial" do
        patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='update'][target='account'] template", 1 do
          assert_select ".hidden[data-controller='finances--account-saved']", "", 1

          assert_select "form:match('action', ?)", finances_account_path(@account), 1
          assert_select "form:match('method', ?)", "post", 1

          assert_select "form", 1 do
            assert_select "input", 3

            assert_select "input[type='hidden'][name='_method'][value='patch']", 1

            assert_select "input:match('id', ?)", "finances_account_form_name", 1
            assert_select "input:match('type', ?)", "text", 1
            assert_select "input:match('value', ?)", "On the bounce", 1

            assert_select "input:match('class', ?)", "hidden", 1
            assert_select "input:match('type', ?)", "submit", 1
          end
        end
      end
    end

    class AccountsPreviewTurboFrame < ViewTest
      test "should return a turbo-stream with action update" do
        patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='replace'][target='#{dom_id(@account)}']", 1
      end

      test "turbo-stream with must contain a template with the account details partial" do
        patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='replace'][target='#{dom_id(@account)}'] template", 1 do
          assert_select "a[id='#{dom_id(@account)}'][href='#{finances_account_path(@account)}']", 1 do
            assert_select "h2", "On the bounce", 1
          end
        end
      end
    end
  end
end
