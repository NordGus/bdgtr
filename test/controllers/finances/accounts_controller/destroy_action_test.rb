require "test_helper"

class Finances::AccountsController::DestroyActionTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:additional)
  end

  test "should destroy account" do
    assert_difference "Account.count", -1 do
      delete finances_account_path(@account)
    end

    assert_response :success
  end

  test "must return a turbo stream response" do
    assert_difference "Account.count", -1 do
      delete finances_account_path(@account)
    end

    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  class ViewTest < ActionDispatch::IntegrationTest
    setup do
      @account = accounts(:additional)
    end

    test "should return the expected amount of turbo-streams" do
      delete finances_account_path(@account)

      assert_select "turbo-stream", 3
    end

    class AccountTurboFrame < ViewTest
      test "should return a turbo-stream with action update" do
        delete finances_account_path(@account)

        assert_select "turbo-stream[action='update'][target='account']", 1
      end

      test "turbo-stream with must contain a template with the account details partial" do
        delete finances_account_path(@account)

        assert_select "turbo-stream[action='update'][target='account'] template", 1 do
          assert_select ".hidden[data-controller='finances--account-saved']", "", 1

          assert_select "form:match('action', ?)", finances_account_path(@account), 1
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

    class AccountsPreviewTurboFrame < ViewTest
      test "should return a turbo-stream with action remove" do
        delete finances_account_path(@account)

        assert_select "turbo-stream[action='remove'][target='#{dom_id(@account)}']", 1
      end
    end

    class ToastsTurboFrame < ViewTest
      test "should return a turbo-stream with action append" do
        delete finances_account_path(@account)

        assert_select "turbo-stream[action='append'][target='toasts']", 1
      end

      test "turbo-stream with must contain a template with the success toast" do
        delete finances_account_path(@account)

        assert_select "turbo-stream[action='append'][target='toasts'] template", 1 do
          assert_select "div[data-controller='toast']", 1 do
            assert_select "p", 1 do
              assert_select "span", @account.name, 1
            end
          end
        end
      end
    end
  end
end
