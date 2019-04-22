class CreateMonetaryTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :monetary_transactions do |t|
      t.references :company, foreign_key: true
      t.decimal :value, precision: 9, scale: 2
      t.string :description
      t.string :mode

      t.timestamps
    end
  end
end
