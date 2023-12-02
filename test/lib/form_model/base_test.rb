require 'test_helper'

class FormModel::BaseTest < ActiveSupport::TestCase
  class ValidationTest < self
    test "url presence" do
      form = ::FormModel::Base.new(url: nil, http_method: :test)

      assert_not form.valid?, "must be invalid"
      assert_equal({ url: ["can't be blank"] }, form.errors.messages, "must return the expected error messages")
    end

    test "http_method presence" do
      form = ::FormModel::Base.new(url: "The Art of War", http_method: nil)

      assert_not form.valid?, "must be invalid"
      assert_equal({ http_method: ["can't be blank"] },
                   form.errors.messages,
                   "must return the expected error messages")
    end
  end

  class InstanceMethodTest < self
    class PersistedTest < self
      test "raises NotImplementedError" do
        form = ::FormModel::Base.new(url: "The Art of War", http_method: :sabaton)

        assert_raises NotImplementedError do
          form.persisted?
        end
      end
    end
  end
end
