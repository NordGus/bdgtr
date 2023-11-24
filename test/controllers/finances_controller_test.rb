require "test_helper"

class FinancesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get finances_show_url
    assert_response :success
  end
end
