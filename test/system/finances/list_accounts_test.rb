require "application_system_test_case"

class Finances::ListAccountsTest < ApplicationSystemTestCase
  test "must display the add account button on in the header" do
    visit finances_path

    find("#header").assert_selector "a[data-finances-target='new']", text: "Add", visible: true
  end

  test "must not display the save account button on in the header" do
    visit finances_path

    find("#header").assert_selector "a[data-finances-target='save']", text: "Save", visible: false
  end

  test "must not display the back button on in the header" do
    visit finances_path

    find("#header").assert_selector "a[data-finances-target='back']", visible: false
  end

  test "the accounts turbo-frame must be viable" do
    visit finances_path

    assert_selector "turbo-frame#accounts", visible: true
  end

  test "the account turbo-frame must not be viable" do
    visit finances_path

    assert_selector "turbo-frame#account", visible: false
  end

  test "the modal container must not be viable" do
    visit finances_path

    assert_selector "#modal", visible: false
  end

  test "check all the accounts in the system" do
    visit finances_path

    accounts_container = find('turbo-frame#accounts')

    accounts.each do |account|
      accounts_container.assert_selector "a[id=#{dom_id account}][href='#{finances_account_path(account)}'] h2",
                                         text: account.name,
                                         visible: true
    end
  end
end
