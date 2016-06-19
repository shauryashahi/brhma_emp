class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :name
      t.string :email
      t.date :date_of_birth
      t.string :gender
      t.integer :state, :default => 0
      t.string :location
      t.string :phone_number

      t.timestamps null: false
    end
  end
end
