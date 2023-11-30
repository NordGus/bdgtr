require "application_system_test_case"

class Finances::UpdateAccountTest < ApplicationSystemTestCase
  setup do
    @account = Account.create(name: "Beyond Good and Evil")
  end

  teardown do
    @account.destroy
  end

  def updated_account_name
    "The Gay Science"
  end

  def duplicated_account_name
    accounts(:personal).name
  end
end
