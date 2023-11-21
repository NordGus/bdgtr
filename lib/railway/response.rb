# frozen_string_literal: true

class Response
  attr_accessor :type, :args

  def initialize(type, *args)
    super()

    self.type = type
    self.args = args
  end

  def self.success(*args)
    new(:success, *args)
  end

  def self.failure(*args)
    new(:failure, *args)
  end
end
