class CreateBoatCategories < ActiveRecord::Migration
  def change
    create_table :boat_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
