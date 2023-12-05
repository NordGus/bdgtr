require "test_helper"

class Finances::AccountFormTest < ActiveSupport::TestCase
  class ValidationsTest < self
    test "name presence" do
      parameters = { name: nil, url: "example.com", http_method: :post }
      form = ::Finances::AccountForm.new(**parameters)

      assert_not form.valid?
      assert_equal({name: ["can't be blank"]}, form.errors.messages, "must return the expected errors")
    end

    test "name length" do
      parameters = { name: "Test", url: "example.com", http_method: :post }
      expected_length = ::Finances::AccountForm::MINIMUM_NAME_LENGTH
      form = ::Finances::AccountForm.new(**parameters)

      assert_not form.valid?
      assert_equal({name: ["is too short (minimum is #{expected_length} characters)"]},
                   form.errors.messages,
                   "must return the expected errors")
    end

    test "url presence" do
      parameters = { name: "Don't panic", url: nil, http_method: :post }
      form = ::Finances::AccountForm.new(**parameters)

      assert_not form.valid?
      assert_equal({url: ["can't be blank"]}, form.errors.messages, "must return the expected errors")
    end

    test "http_method presence" do
      parameters = { name: "Don't panic", url: "example.com", http_method: nil }
      form = ::Finances::AccountForm.new(**parameters)

      assert_not form.valid?
      assert_equal({http_method: ["can't be blank"]}, form.errors.messages, "must return the expected errors")
    end
  end

  class PersistedImplementationTest < self
    test "returns false when id attribute is not presents" do
      form = Finances::AccountForm.new(id: nil, name: "Don't panic", url: "example.com", http_method: :post)

      assert_equal false, form.persisted?, "must be false"
    end

    test "returns true when id attribute is presents" do
      form = Finances::AccountForm.new(id: 42, name: "Don't panic", url: "example.com", http_method: :post)

      assert_equal true, form.persisted?, "must be true"
    end
  end
end