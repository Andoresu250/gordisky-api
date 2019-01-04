class CreateLoans < ActiveRecord::Migration[5.2]
  def change
    create_table :loans do |t|
      t.decimal :amount, precision: 9, scale: 2
      t.decimal :interest, precision: 2, scale: 2
      t.decimal :debt, precision: 9, scale: 2
      t.integer :fees
      t.integer :fees_fulfilled
      t.integer :remaining_fees
      t.integer :frequency
      t.decimal :paid, precision: 9, scale: 2
      t.date :last_paid
      t.date :next_paid
      t.decimal :fee_value, precision: 9, scale: 2
      t.references :person, foreign_key: true
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
