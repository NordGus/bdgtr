require "test_helper"

class FinancesController::AppletActionTest < ActionDispatch::IntegrationTest
  test "responses to get with a success" do
    get finances_path

    assert_response :success
  end

  class View < ActionDispatch::IntegrationTest
    test "contains a single element with id finances" do
      get finances_path

      assert_select "#finances", 1
      assert_select "#finances:match('data-controller', ?)", "finances", 1
      assert_select "#finances:match('data-action', ?)", "finances--account-saved:success->finances#hideAccount", 1
    end

    test "contains a single toasts container positioned relative to the finances parent" do
      get finances_path

      assert_select "#toasts", "", 1
      assert_select "#toasts.absolute", 1
    end

    test "contains a single modal skeleton positioned relative to the finances parent" do
      get finances_path

      assert_select "#modal.absolute.hidden.top-0.right-0.bottom-0.left-0", 1 do
        assert_select ".flex-grow.flex.flex-col.relative", 1 do
          assert_select ".flex-grow.block.opacity-60[data-action='click->modal#close']", "", 1
          assert_select ".block.absolute.bottom-0.left-0.right-0", "", 1
        end

        assert_select "#modal_body", "", 1
      end
    end

    test "contains a single element with id header" do
      get finances_path

      assert_select "#header", 1 do
        assert_select "#title", 1 do
          assert_select "a.hidden:match('data-finances-target', ?)", "back", 1
          assert_select "a.hidden:match('data-action', ?)", "click->finances#hideAccount", 1
          assert_select "h1", "Finances", 1
        end

        assert_select "a:match('data-turbo-frame', ?)", "account", 2

        assert_select "a:match('data-finances-target', ?)", "new", 1
        assert_select "a:match('data-action', ?)", "click->finances#displayAccount", 1
        assert_select "a:match('href', ?)", new_finances_account_path, 1
        assert_select "a", "Add", 1

        assert_select "a:match('data-finances-target', ?)", "save", 1
        assert_select "a:match('data-action', ?)", "click->finances#saveAccount", 1
        assert_select "a:match('data-turbo', ?)", "true", 1
        assert_select "a", "Save", 1
      end
    end

    test "contains a single turbo-frame with id accounts" do
      get finances_path

      assert_select "turbo-frame#accounts", "", 1
    end

    test "contains a single hidden turbo-frame with id account" do
      get finances_path

      assert_select "turbo-frame#account.hidden", "", 1
    end

    test "contains a single element with id menu" do
      get finances_path

      assert_select "#menu", 1 do
        assert_select "a", "Finances", 1
      end
    end
  end
end
