require "test_helper"

class FinancesControllerTest < ActionDispatch::IntegrationTest
  class ShowAction < ActionDispatch::IntegrationTest
    test "responses to get with a success" do
      get finances_path

      assert_response :success
    end

    class View < ActionDispatch::IntegrationTest
      test "contains a single element with id finances" do
        get finances_path

        assert_select "#finances", 1
      end

      test "contains a single element with id title" do
        get finances_path

        assert_select "#title", 1 do
          assert_select "h1", 1
          assert_select "h1", "Finances"
          assert_select "a:match('id', ?)", "add_account", 1
          assert_select "a#add_account", "Add"
        end
      end

      test "contains a single element with id accounts" do
        get finances_path

        assert_select "#accounts", 1
        assert_select "#accounts", ""
      end

      test "contains a single hidden element with id account" do
        get finances_path

        assert_select "#account", 1
        assert_select "#account", ""
        assert_select "#account.hidden", 1, ""
        assert_select "#account.hidden", ""
      end

      test "contains a single element with id menu" do
        get finances_path

        assert_select "#menu", 1
        assert_select "#menu", "Here goes the menu"
      end
    end
  end
end
