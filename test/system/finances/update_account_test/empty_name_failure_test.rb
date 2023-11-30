require './test/system/finances/update_account_test'

class Finances::UpdateAccountTest::EmptyNameFailureTest < Finances::UpdateAccountTest
  test "must not update the name of the account" do
    visit finances_path

    click_on @account.name

    name_input = find "#account form input[name='finances_account_form[name]']"
    name_input.fill_in with: ""

    find("#header a[data-finances-target='save']", text: "Save").click

    assert_selector "#accounts a##{dom_id @account}", text: @account.name, visible: false
  end

  test "must return the details view with the name input marked as having an error" do
    visit finances_path

    click_on @account.name

    name_input = find "#account form input[name='finances_account_form[name]']"
    name_input.fill_in with: ""

    find("#header a[data-finances-target='save']", text: "Save").click

    assert_selector "#account form input[name='finances_account_form[name]']", class: "border-red-500"
  end


  test "must return the details view with the name input error list" do
    visit finances_path

    click_on @account.name

    name_input = find "#account form input[name='finances_account_form[name]']"
    name_input.fill_in with: ""

    find("#header a[data-finances-target='save']", text: "Save").click

    assert_selector "#account form label[for='finances_account_form_name'] span.text-red-500", text: "can't be blank"
  end
end
