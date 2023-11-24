require "test_helper"

class Railway::ResponseTest < ActiveSupport::TestCase
  test "#new" do
    response = Railway::Response.new(:test, "this", "is", "a", "test")

    assert_instance_of Railway::Response, response, "failed to initialize"
    assert_equal response.type, :test, "invalid type"
    assert_equal response.args, %w[this is a test], "invalid arguments"
  end

  test "#success" do
    response = Railway::Response.success("this", "is", "a", "test")

    assert_equal response.type, :success, "invalid type"
    assert_equal response.args, %w[this is a test], "invalid arguments"
  end

  test "#failure" do
    response = Railway::Response.failure("this", "is", "a", "test")

    assert_equal response.type, :failure, "invalid type"
    assert_equal response.args, %w[this is a test], "invalid arguments"
  end

  test "#and_then when success" do
    response = Railway::Response.success("this", "is", "a", "test")

    assert_equal response.and_then{ |*args| Railway::Response.new(:test, "this comes from a block") }.type, :test, "bad block execution"
    assert_equal response.and_then{ |*args| Railway::Response.new(:test, "this comes from a block") }.args, ["this comes from a block"], "bad block execution"
  end

  test "#and_then when failure" do
    response = Railway::Response.failure("this", "is", "a", "test")

    assert_equal response.and_then{ |*args| Railway::Response.new(:test, "this comes from a block") }, response, "bad block execution"
  end

  test "#if_failed when success" do
    response = Railway::Response.success("this", "is", "a", "test")

    assert_equal response.if_failed{ |*args| Response.new(:test, "this comes from a block") }, response, "bad block execution"
  end

  test "#if_failed when failure" do
    response = Railway::Response.failure("this", "is", "a", "test")

    assert_equal response.if_failed{ |*args| Railway::Response.new(:test, "this comes from a block") }.type, :test, "bad block execution"
    assert_equal response.if_failed{ |*args| Railway::Response.new(:test, "this comes from a block") }.args, ["this comes from a block"], "bad block execution"
  end

  test "#success? returns true only if type equal :success" do
    response = Railway::Response.success("this", "is", "a", "test")

    assert response.success?, "invalid implementation"
  end

  test "#success? returns false if type is anything other than :success" do
    response = Railway::Response.new(:test, "this", "is", "a", "test")

    assert_not response.success?, "invalid implementation"
  end
end
