require "test_helper"

class BalanceController::AppletActionTest < ActionDispatch::IntegrationTest
  test "responses to get with a success" do
    get balance_path

    assert_response :success
  end

  class ViewTest < self
    test "contains a single element with id finances" do
      get balance_path

      assert_select "#balance", 1
      assert_select "#balance:match('data-controller', ?)", "modal", 1
    end

    test "contains a single toasts container positioned relative to the finances parent" do
      get balance_path

      assert_select "#toasts", "", 1
      assert_select "#toasts.absolute", 1
    end

    test "contains a single modal skeleton positioned relative to the finances parent" do
      get balance_path

      assert_select "#modal.absolute.hidden.top-0.right-0.bottom-0.left-0", 1 do
        assert_select ".flex-grow.flex.flex-col.relative", 1 do
          assert_select ".flex-grow.block.opacity-60[data-action='click->modal#close']", "", 1
          assert_select ".block.absolute.bottom-0.left-0.right-0", "", 1
        end

        assert_select "#modal_body", "", 1
      end
    end

    test "contains a single element with id header" do
      get balance_path

      assert_select "#header", 1 do
        assert_select "#title", 1 do
          assert_select "h1", "Balance", 1
        end

        assert_select "a", "Add", 1
      end
    end

    test "contains a single turbo-frame with id accounts" do
      get balance_path

      assert_select "turbo-frame#transactions", "", 1
    end

    test "contains a single element with id menu" do
      get balance_path

      assert_select "#menu", 1 do
        assert_select "a", "Balance", 1
      end
    end
  end
end
