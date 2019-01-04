class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :loan, foreign_key: true
      t.integer :number
      t.date :date
      t.date :paid_at
      t.float :value
      t.float :paid_value
      t.string :state, default: "pendiente"

      t.timestamps
    end
  end
end
