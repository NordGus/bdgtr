# frozen_string_literal: true

module Railway
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

    def and_then
      return yield(*args) if type == SUCCESS

      self
    end

    def if_failed
      return yield(*args) if type == FAILURE

      self
    end
  end
end