class CreateBoats < ActiveRecord::Migration
  def change
    create_table :boats do |t|
      t.string :name
      t.string :manufacturer
      t.decimal :daily_price, precision: 8, scale: 2
      t.integer :year
      t.string :model
      t.decimal :daily_price, precision: 8, scale: 2
      t.integer :guest_capacity
      t.references :boat_category, index: true

      t.timestamps null: false
    end
    add_foreign_key :boats, :boat_categories
  end
end
