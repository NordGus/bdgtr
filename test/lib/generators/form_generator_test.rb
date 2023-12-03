require "test_helper"
require "generators/form/form_generator"

class FormGeneratorTest < Rails::Generators::TestCase
  tests FormGenerator
  destination Rails.root.join("tmp/generators")
  setup :prepare_destination

  test "should add a form model file" do
    run_generator ["Thing::Thing"]

    assert_file "app/forms/thing/thing_form.rb"
  end

  test "should add form_model boilerplate" do
    run_generator ["Thing::Thing"]

    assert_file "app/forms/thing/thing_form.rb" do |content|
      assert_match /class Thing::ThingForm/, content, "must create the expected class"
      assert_match /FormModel::Base/, content, "must inherit from FormModel::Base"
      assert_match /def persisted?/, content, "must add the persisted? method"
    end
  end

  test "should generate attributes" do
    run_generator %w[thing/thing id:integer name]

    assert_file "app/forms/thing/thing_form.rb" do |content|
      assert_match /attribute :id, :integer/, content, "must create the id attribute as an integer"
      assert_match /attribute :name, :string/, content, "must create the name attribute as an string"

      assert_match /initialize\(id:, name:, url:, http_method:\)/,
                   content,
                   "must add attributes to the initialize method"
    end
  end

  test "should add a form model test file" do
    run_generator ["Thing::Thing"]

    assert_file "test/forms/thing/thing_form_test.rb"
  end

  test "should add form_model test boilerplate" do
    run_generator %w[thing/thing id:integer name]

    assert_file "test/forms/thing/thing_form_test.rb" do |content|
      assert_match /require "test_helper"/, content, "must require test_helper"
      assert_match /class Thing::ThingFormTest/, content, "must create the expected class"
      assert_match /ActiveSupport::TestCase/, content, "must inherit from ActiveSupport::TestCase"
      assert_match /Thing::ThingForm.new\(id: nil, name: nil, url: nil, http_method: nil\)/,
                   content,
                   "must initialize correctly the form_model"
    end
  end
end
