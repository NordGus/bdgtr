require "test_helper"

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

  test "#and_then when success" do
    response = Response.success("this is a test")

    assert_equal response.and_then{ |*args| Response.new(:test, "this comes from a block") }.type, :test, "bad block execution"
    assert_equal response.and_then{ |*args| Response.new(:test, "this comes from a block") }.args, ["this comes from a block"], "bad block execution"
  end

  test "#and_then when failure" do
    response = Response.failure("this is a test")

    assert_equal response.and_then{ |*args| Response.new(:test, "this comes from a block") }, response, "bad block execution"
  end

  test "#if_failed when success" do
    response = Response.success("this is a test")

    assert_equal response.if_failed{ |*args| Response.new(:test, "this comes from a block") }, response, "bad block execution"
  end

  test "#if_failed when failure" do
    response = Response.failure("this is a test")

    assert_equal response.if_failed{ |*args| Response.new(:test, "this comes from a block") }.type, :test, "bad block execution"
    assert_equal response.if_failed{ |*args| Response.new(:test, "this comes from a block") }.args, ["this comes from a block"], "bad block execution"
  end
end
