require "test_helper"

require './lib/railway/response'

class ResponseTest < ActiveSupport::TestCase
  test "#new" do
    response = Response.new(:test, "this is a test")

    assert_instance_of Response, response, "failed to initialize"
    assert_equal response.type, :test, "invalid type"
    assert_equal response.args, ["this is a test"], "invalid arguments"
  end

  test "#success" do
    response = Response.success("this is a test")

    assert_equal response.type, :success, "invalid type"
    assert_equal response.args, ["this is a test"], "invalid arguments"
  end

  test "#failure" do
    response = Response.failure("this is a test")

    assert_equal response.type, :failure, "invalid type"
    assert_equal response.args, ["this is a test"], "invalid arguments"
  end
end
