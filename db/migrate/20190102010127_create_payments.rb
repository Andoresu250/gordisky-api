class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :loan, foreign_key: true
      t.integer :number
      t.date :date
      t.date :paid_at
      t.decimal :value, precision: 9, scale: 2
      t.decimal :paid_value, precision: 9, scale: 2
      t.string :state, default: "pendiente"

      t.timestamps
    end
  end
end
