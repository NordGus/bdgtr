# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

unless Account.any?
  ["Personal Account", "Expense Account", "Additional Pseudo Account"].each do |account|
    puts "Creating #{account}"
    Account.create!(name: account)
  end
end

unless Transaction.any?
  personal_account = Account.find_by_name("Personal Account")
  expense_account = Account.find_by_name("Expense Account")
  additional_account = Account.find_by_name("Additional Pseudo Account")

  starting_at = Date.today

  puts "Creating expense transactions"

  offset_in_days = 30
  expenses_amounts = [BigDecimal("7.69"), BigDecimal("11.70"), BigDecimal("24.69"), BigDecimal("9.69")].cycle

  offset_in_days.times do |days|
    next unless days.even?

    Transaction.create!(
      from: personal_account,
      to: expense_account,
      amount: expenses_amounts.next,
      issued_at: starting_at - (offset_in_days - days + 1).days,
      executed_at: starting_at - (offset_in_days - days).days
    )
  end

  puts "Creating future expected expenses"

  Transaction.create!(
    from: personal_account,
    to: expense_account,
    amount: BigDecimal("42.69"),
    issued_at: starting_at + 1.week,
    executed_at: nil
  )

  Transaction.create!(
    from: personal_account,
    to: expense_account,
    amount: BigDecimal("69.77"),
    issued_at: starting_at + 2.weeks,
    executed_at: nil
  )

  Transaction.create!(
    from: personal_account,
    to: expense_account,
    amount: BigDecimal("13.13"),
    issued_at: starting_at + 3.weeks,
    executed_at: nil
  )

  puts "Creating income transactions"

  income_amount = BigDecimal("6942.07")

  Transaction.create!(
    from: additional_account,
    to: personal_account,
    amount: income_amount,
    issued_at: starting_at - 32.days,
    executed_at: starting_at - 30.days
  )

  Transaction.create!(
    from: additional_account,
    to: personal_account,
    amount: 6942.07,
    issued_at: starting_at - 17.days,
    executed_at: starting_at - 15.days
  )

  Transaction.create!(
    from: additional_account,
    to: personal_account,
    amount: income_amount,
    issued_at: starting_at - 2.days,
    executed_at: starting_at
  )

  Transaction.create!(
    from: additional_account,
    to: personal_account,
    amount: income_amount,
    issued_at: starting_at + 13.days,
    executed_at: nil
  )

end