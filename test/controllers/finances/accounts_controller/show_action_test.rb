require "test_helper"

class Finances::AccountsController::ShowActionTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:additional)
  end

  test "should show account" do
    get finances_account_path(@account)

    assert_response :success
  end

  test "must return a turbo stream response" do
    get finances_account_path(@account)

    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  class ViewTest < ActionDispatch::IntegrationTest
    setup do
      @account = accounts(:additional)
    end

    test "should return the expected amount of turbo-streams" do
      get finances_account_path(@account)

      assert_select "turbo-stream", 2
    end

    class AccountTurboStream < ViewTest
      test "should return on turbo-stream that updates the account turbo-frame" do
        get finances_account_path(@account)

        assert_select "turbo-stream[action='update'][target='account']", 1
      end

      test "should return the expected template inside the turbo-stream" do
        get finances_account_path(@account)

        assert_select "turbo-stream[action='update'][target='account'] template", 1 do
          assert_select "form:match('action', ?)", finances_account_path(@account), 1
          assert_select "form:match('method', ?)", "post", 1

          assert_select "form", 1 do
            assert_select "input:match('class', ?)", "hidden", 1
            assert_select "input:match('type', ?)", "submit", 1
          end

          assert_select "a[data-action='click->modal#open']", "Delete Account", 1
        end
      end
    end

    class ModalBodyTurboStream < ViewTest
      test "should return on turbo-stream that updates the account turbo-frame" do
        get finances_account_path(@account)

        assert_select "turbo-stream[action='update'][target='modal_body']", 1
      end

      test "should return the expected template inside the turbo-stream" do
        get finances_account_path(@account)

        assert_select "turbo-stream[action='update'][target='modal_body'] template", 1 do
          assert_select(
            "a[href='#{finances_account_path(@account)}'][data-turbo-method='delete'][data-turbo-frame='account'][data-action='click->modal#close']",
            "Yes",
            1
          )

          assert_select "a[data-action='click->modal#close']", "No", 1
        end
      end
    end
  end
end
