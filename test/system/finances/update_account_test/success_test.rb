require './test/system/finances/update_account_test'

class Finances::UpdateAccountTest::SuccessTest < Finances::UpdateAccountTest
  test "must update the name of the account" do
    visit finances_path

    click_on @account.name

    name_input = find "#account form input[name='finances_account_form[name]']"
    name_input.fill_in with: updated_account_name

    find("#header a[data-finances-target='save']", text: "Save").click

    assert_selector "#accounts a##{dom_id @account}", text: updated_account_name
  end

  test "must render a success toast notification" do
    visit finances_path

    click_on @account.name

    name_input = find "#account form input[name='finances_account_form[name]']"
    name_input.fill_in with: updated_account_name

    find("#header a[data-finances-target='save']", text: "Save").click

    assert_selector "#toasts div[data-controller='toast'].bg-green-500", count: 1
    assert_selector "#toasts div[data-controller='toast'] a[href='#{finances_account_path(@account)}']",
                    text: updated_account_name,
                    count: 1
  end
end
