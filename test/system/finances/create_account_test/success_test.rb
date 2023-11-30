require './test/system/finances/create_account_test'

class Finances::CreateAccountTest::SuccessTest < Finances::CreateAccountTest
  test "must create the name of the account" do
    visit finances_path

    click_on "Add"

    name_input = find "#account form input[name='finances_account_form[name]']"
    name_input.fill_in with: new_account_name

    find("#header a[data-finances-target='save']", text: "Save").click

    assert_selector "#accounts a", text: new_account_name
  end

  test "must render a success toast notification" do
    visit finances_path

    click_on "Add"

    name_input = find "#account form input[name='finances_account_form[name]']"
    name_input.fill_in with: new_account_name

    find("#header a[data-finances-target='save']", text: "Save").click

    assert_selector "#toasts div[data-controller='toast'].bg-green-500", count: 1
    assert_selector "#toasts div[data-controller='toast'] a", text: new_account_name, count: 1
  end
end
