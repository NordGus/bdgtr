require "test_helper"

class MockCommand < Command::Base
  attribute :value, :string

  validates :value, presence: true

  def initialize(value)
    super()

    self.value = value
  end

  def execute
    valid?.and_then { test_action }
  end

  private

  def test_action
    Railway::Response.success(self.value)
  end
end

class Command::BaseTest < ActiveSupport::TestCase
  class ValidationTest < self
    test "validates the data like a ActiveRecord model but return a Railway::Response" do
      command = MockCommand.new(%w(this is a test))

      assert_instance_of Railway::Response, command.valid?, "is not returning expected value"
    end

    test "returns a success Railway::Response with the command instances as it's args" do
      command = MockCommand.new(%w(this is a test))
      response = command.valid?

      assert response.success?, "is not returning expected Railway::Response"
      assert_equal [command], response.args, "invalid args"
    end

    test "returns a failure Railway::Response with a command instances and the errors hash when is not valid" do
      command = MockCommand.new("")
      response = command.valid?

      assert_equal :failure, response.type, "is not returning expected Railway::Response"
      assert_equal [command, command.errors.messages], response.args, "invalid args"
    end
  end
end
