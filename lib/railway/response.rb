# frozen_string_literal: true

class Response
  SUCCESS = :success.freeze
  FAILURE = :failure.freeze

  attr_accessor :type, :args

  def initialize(type, *args)
    super()

    self.type = type
    self.args = args
  end

  def self.success(*args)
    new(SUCCESS, *args)
  end

  def self.failure(*args)
    new(FAILURE, *args)
  end

  def and_then(&block)
    return block.call(*args) if type == SUCCESS

    self
  end

  def if_failed(&block)
    return block.call(*args) if type == FAILURE

    self
  end
end
