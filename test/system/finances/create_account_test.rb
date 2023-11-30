require "application_system_test_case"

class Finances::CreateAccountTest < ApplicationSystemTestCase
  def new_account_name
    "Thus Spoke Zarathustra"
  end

  def duplicated_account_name
    accounts(:personal).name
  end

  def short_account_name
    "Test"
  end
end
