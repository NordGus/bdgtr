class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :from,
                   null: false,
                   foreign_key: { to_table: :accounts, name: :transaction_origin_account_reference },
                   index: { name: :transaction_origin_account_reference }
      t.references :to,
                   null: false,
                   foreign_key: { to_table: :accounts, name: :transaction_destination_account_reference },
                   index: { name: :transaction_destination_account_reference }
      t.decimal :amount, precision: 40, scale: 2
      t.date :issued_at
      t.date :executed_at

      t.timestamps
    end
  end
end
