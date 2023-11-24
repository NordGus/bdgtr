require "test_helper"

class BdgtrControllerTest < ActionDispatch::IntegrationTest
  class RootAction < ActionDispatch::IntegrationTest
    test "should redirect to /finances" do
      get root_path

      assert_redirected_to finances_path
    end
  end
end
