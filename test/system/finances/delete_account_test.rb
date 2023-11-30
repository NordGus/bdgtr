require "application_system_test_case"

class Finances::DeleteAccountTest < ApplicationSystemTestCase
  setup do
    @account = Account.create(name: "Beyond Good and Evil")
  end

  teardown do
    @account.destroy
  end
end
