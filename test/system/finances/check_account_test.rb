require "application_system_test_case"

class Finances::CheckAccountTest < ApplicationSystemTestCase
  test "must not display the add account button on in the header" do
    visit finances_path

    click_on accounts(:personal).name

    find("#header").assert_selector "a[data-finances-target='new']", text: "Add", visible: false
  end

  test "must display the save account button on in the header" do
    visit finances_path

    click_on accounts(:personal).name

    find("#header").assert_selector "a[data-finances-target='save']", text: "Save", visible: true
  end

  test "must display the back button on in the header" do
    visit finances_path

    click_on accounts(:personal).name

    find("#header").assert_selector "a[data-finances-target='back']", visible: true
  end

  test "the accounts turbo-frame must not be viable" do
    visit finances_path

    click_on accounts(:personal).name

    assert_selector "turbo-frame#accounts", visible: false
  end

  test "the account turbo-frame must be viable" do
    visit finances_path

    click_on accounts(:personal).name

    assert_selector "turbo-frame#account", visible: true
  end

  test "the modal container must not be viable" do
    visit finances_path

    click_on accounts(:personal).name

    assert_selector "#modal", visible: false
  end

  test "must display the selected account detail" do
    visit finances_path

    click_on accounts(:personal).name

    find("#account form").has_field? :name, with: accounts(:personal).name, visible: true
  end

  test "the underlying form submit button must be hidden" do
    visit finances_path

    click_on accounts(:personal).name

    find("#account form").has_field? :commit, type: :submit, visible: false
  end
end
