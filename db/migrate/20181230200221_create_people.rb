class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :first_names
      t.string :last_names
      t.string :identification
      t.string :phone
      t.string :address
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
