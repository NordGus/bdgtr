require "test_helper"

class FinancesControllerTest < ActionDispatch::IntegrationTest
  class ShowAction < ActionDispatch::IntegrationTest
    test "responses to get with a success" do
      get finances_path

      assert_response :success
    end

    test "returns a view that contains a single element with id finances" do
      get finances_path

      assert_select "#finances", 1
    end

    test "returns a view that contains a single element with id title" do
      get finances_path

      assert_select "#title", 1 do
        assert_select "h1", 1, "Finances"
        assert_select "p#account-name", 1, ""
      end
    end

    test "returns a view that contains a single element with id accounts" do
      get finances_path

      assert_select "#accounts", 1, ""
    end

    test "returns a view that contains a single element with id account that is hidden" do
      get finances_path

      assert_select "#account.hidden", 1, ""
    end

    test "returns a view that contains a single element with id menu" do
      get finances_path

      assert_select "#menu", 1, "Here goes the menu"
    end
  end
end
