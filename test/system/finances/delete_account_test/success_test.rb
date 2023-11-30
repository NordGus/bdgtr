require './test/system/finances/delete_account_test'

class Finances::DeleteAccountTest::SuccessTest < Finances::DeleteAccountTest
  test "must delete the name of the account" do
    visit finances_path

    click_on @account.name

    find("#account a[data-action='click->modal#open']", text: "Delete Account").click
    find("#modal a[href='#{finances_account_path(@account)}'][data-turbo-method='delete']", text: "Yes").click

    assert_no_selector "#accounts a##{dom_id @account}", text: @account.name
  end

  test "must render a success toast notification" do
    visit finances_path

    click_on @account.name

    find("#account a[data-action='click->modal#open']", text: "Delete Account").click
    find("#modal a[href='#{finances_account_path(@account)}'][data-turbo-method='delete']", text: "Yes").click

    assert_selector "#toasts div[data-controller='toast'].bg-green-500", count: 1
    assert_selector "#toasts div[data-controller='toast'] span", text: @account.name, count: 1
  end
end
