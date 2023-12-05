require "test_helper"

class BalanceControllerTest < ActionDispatch::IntegrationTest
  test "should get applet" do
    get balance_applet_url
    assert_response :success
  end
end
