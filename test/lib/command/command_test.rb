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

class CommandTest < ActiveSupport::TestCase
  test "#valid? validates the data like a ActiveRecord model but return a Railway::Response" do
    command = MockCommand.new(%w(this is a test))

    assert_instance_of Railway::Response, command.valid?, "is not returning expected value"
  end

  test "#valid? returns a success Railway::Response with the command instances as it's args" do
    command = MockCommand.new(%w(this is a test))

    assert command.valid?.success?, "is not returning expected Railway::Response"
    assert_equal command.valid?.args, [command], "invalid args"
  end

  test "#valid? returns a failure Railway::Response when is invalid, with the command instances as it's first arg and the errors hash as its second arg" do
    command = MockCommand.new("")

    assert_equal command.valid?.type, :failure, "is not returning expected Railway::Response"
    assert_equal command.valid?.args.first, command, "invalid args"
    assert_equal command.valid?.args.last, command.errors.messages, "invalid args"
  end
end
