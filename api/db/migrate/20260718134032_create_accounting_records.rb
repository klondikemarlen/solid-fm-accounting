class CreateAccountingRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :transaction_type, null: false
      t.datetime :deleted_at, precision: 6

      t.timestamps

      t.index :code, unique: true, where: "deleted_at IS NULL"
      t.index :name, unique: true, where: "deleted_at IS NULL"
    end

    add_check_constraint :categories,
      "transaction_type IN ('income', 'expense', 'both')",
      name: "categories_transaction_type"

    add_check_constraint :categories,
      "btrim(code) <> '' AND btrim(name) <> ''",
      name: "categories_code_and_name_present"

    create_table :payment_methods do |t|
      t.string :name, null: false
      t.datetime :deleted_at, precision: 6

      t.timestamps

      t.index :name, unique: true, where: "deleted_at IS NULL"
    end

    add_check_constraint :payment_methods, "btrim(name) <> ''", name: "payment_methods_name_present"

    create_table :accounts do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.string :name, null: false
      t.string :account_type, null: false
      t.datetime :deleted_at, precision: 6

      t.timestamps

      t.index [ :user_id, :name ], unique: true, where: "deleted_at IS NULL"
    end

    add_check_constraint :accounts,
      "account_type IN ('cash', 'chequing', 'savings', 'credit_card')",
      name: "accounts_account_type"

    add_check_constraint :accounts, "btrim(name) <> ''", name: "accounts_name_present"

    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :category, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.string :transaction_type, null: false
      t.date :transaction_date, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :vendor
      t.text :description
      t.datetime :deleted_at, precision: 6

      t.timestamps

      t.index [ :user_id, :transaction_date ]
    end

    add_check_constraint :transactions, "amount > 0", name: "transactions_amount_positive"
    add_check_constraint :transactions,
      "transaction_type IN ('income', 'expense')",
      name: "transactions_transaction_type"
  end
end
