require "test_helper"

class Railway::ResponseTest < ActiveSupport::TestCase
  class ClassMethodTest < self
    class SuccessTest < self
      test "returns an instance with type success" do
        response = Railway::Response.success("learn", "to", "fly")

        assert_equal response.type, :success, "invalid type"
      end

      test "returns an instance with the arguments" do
        response = Railway::Response.success("learn", "to", "fly")

        assert_equal response.args, %w[learn to fly], "invalid arguments"
      end
    end

    class FailureTest < self
      test "returns an instance with type failure" do
        response = Railway::Response.failure("learn", "to", "fly")

        assert_equal response.type, :failure, "invalid type"
      end

      test "returns an instance with the arguments" do
        response = Railway::Response.failure("learn", "to", "fly")

        assert_equal response.args, %w[learn to fly], "invalid arguments"
      end
    end
  end

  class InstanceMethodTest < self
    # IsSuccessTest actually test the instance method :success?
    class IsSuccessTest < self
      test "returns true only if type equal success" do
        response = Railway::Response.new(:success, "making", "a", "fire")

        assert response.success?, "invalid implementation"
      end

      test "returns false if type is anything other than success" do
        response = Railway::Response.new(:test, "making", "a", "fire")

        assert_not response.success?, "invalid implementation"
      end
    end

    class AndThenTest < self
      test "when is from a successful response" do
        response = Railway::Response.new(:success, "it", "started", "with", "a", "spark")

        assert_equal block_response_return,
                     response.and_then{ |*args| block_response_return },
                     "must return the response inside the block"
      end

      test "when is from any other type of response" do
        response = Railway::Response.new(:not_success, "this", "is", "a", "test")

        assert_equal response,
                     response.and_then{ |*args| block_response_return },
                     "must return itself"
      end

      def block_response_return
        @block_response_return ||= Railway::Response.new(:from_block, "I'm something from nothing")
      end
    end

    class IfFailedTest < self
      test "when is from a failed response" do
        response = Railway::Response.new(:failure, "it", "was", "the", "feast", "and", "the", "famine")

        assert_equal block_response_return,
                     response.if_failed{ |*args| block_response_return },
                     "must return the response inside the block"
      end

      test "when is from any other type of response" do
        response = Railway::Response.new(:not_failure, "it", "was", "the", "feast", "and", "the", "famine")

        assert_equal response,
                     response.and_then{ |*args| block_response_return },
                     "must return itself"
      end

      def block_response_return
        @block_response_return ||= Railway::Response.new(
          :from_block,
          "Hey, where is the monument?",
          "To the dreams we forget?"
        )
      end
    end
  end
end
