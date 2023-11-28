require "application_system_test_case"

class Finances::AccountsTest < ApplicationSystemTestCase
  setup do
    @finances_account = finances_accounts(:one)
  end

  test "visiting the index" do
    visit finances_accounts_url
    assert_selector "h1", text: "Accounts"
  end

  test "should create account" do
    visit finances_accounts_url
    click_on "New account"

    click_on "Create Account"

    assert_text "Account was successfully created"
    click_on "Back"
  end

  test "should update Account" do
    visit finances_account_url(@finances_account)
    click_on "Edit this account", match: :first

    click_on "Update Account"

    assert_text "Account was successfully updated"
    click_on "Back"
  end

  test "should destroy Account" do
    visit finances_account_url(@finances_account)
    click_on "Destroy this account", match: :first

    assert_text "Account was successfully destroyed"
  end
end
