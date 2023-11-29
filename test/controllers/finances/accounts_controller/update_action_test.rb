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

    test "should return the expected amount of turbo-streams" do
      patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

      assert_select "turbo-stream", 3
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

          assert_select "a[data-action='click->modal#open']", "Delete Account", 1
        end
      end
    end

    class AccountsPreviewTurboFrame < ViewTest
      test "should return a turbo-stream with action replace" do
        patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='replace'][target='#{dom_id(@account)}']", 1
      end

      test "turbo-stream with must contain a template with the account preview partial" do
        patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='replace'][target='#{dom_id(@account)}'] template", 1 do
          assert_select "a[id='#{dom_id(@account)}'][href='#{finances_account_path(@account)}']", 1 do
            assert_select "h2", "On the bounce", 1
          end
        end
      end
    end

    class ToastsTurboFrame < ViewTest
      test "should return a turbo-stream with action append" do
        patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='append'][target='toasts']", 1
      end

      test "turbo-stream with must contain a template with the success toast" do
        patch finances_account_path(@account), params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='append'][target='toasts'] template", 1 do
          assert_select "div[data-controller='toast']", 1 do
            assert_select "p", 1 do
              assert_select "a[href='#{finances_account_path(@account)}'][data-turbo-frame='account'][data-action='click->finances#displayAccount']",
                            "On the bounce",
                            1
            end
          end
        end
      end
    end
  end
end
