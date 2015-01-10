class CreateBoatFeatures < ActiveRecord::Migration
  def change
    create_table :boat_features do |t|
      t.string :name
      t.references :boat_category, index: true

      t.timestamps null: false
    end
    add_foreign_key :boat_features, :boat_categories
  end
end
