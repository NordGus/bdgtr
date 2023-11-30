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
    test "should return the expected amount of turbo-streams" do
      post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

      assert_select "turbo-stream", 4
    end

    class AccountTurboFrame < ViewTest
      test "should return a turbo-stream with action update" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='update'][target='account']", 1
      end

      test "turbo-stream with must contain a template with the account details partial" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='update'][target='account'] template", 1 do
          assert_select ".hidden[data-controller='finances--account-saved']", "", 1

          assert_select "form:match('method', ?)", "post", 1

          assert_select "form", 1 do
            assert_select "input", 3
            assert_select "input[type='hidden'][name='_method'][value='patch']", 1
            assert_select "input:match('class', ?)", "hidden", 1
            assert_select "input:match('type', ?)", "submit", 1
          end

          assert_select "a[data-action='click->modal#open']", "Delete Account", 1
        end
      end
    end

    class ModalBodyTurboStream < ViewTest
      test "should return on turbo-stream that updates the account turbo-frame" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='update'][target='modal_body']", 1
      end

      test "should return the expected template inside the turbo-stream" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='update'][target='modal_body'] template", 1 do
          assert_select(
            "a[data-turbo-method='delete'][data-turbo-frame='account'][data-action='click->modal#close']",
            "Yes",
            1
          )

          assert_select "a[data-action='click->modal#close']", "No", 1
        end
      end
    end

    class AccountsPreviewTurboFrame < ViewTest
      test "should return a turbo-stream with action replace" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='prepend'][target='accounts']", 1
      end

      test "turbo-stream with must contain a template with the account preview partial" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='prepend'][target='accounts'] template", 1 do
          assert_select "a", 1 do
            assert_select "h2", "On the bounce", 1
          end
        end
      end
    end

    class ToastsTurboFrame < ViewTest
      test "should return a turbo-stream with action append" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='append'][target='toasts']", 1
      end

      test "turbo-stream with must contain a template with the success toast" do
        post finances_accounts_path, params: { finances_account_form: { name: "On the bounce" } }

        assert_select "turbo-stream[action='append'][target='toasts'] template", 1 do
          assert_select "div[data-controller='toast']", 1 do
            assert_select "p", 1 do
              assert_select "a[data-turbo-frame='account'][data-action='click->finances#displayAccount']",
                            "On the bounce",
                            1
            end
          end
        end
      end
    end
  end
end
