class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :boat, index: true
      t.string :description

      t.timestamps null: false
    end
    add_foreign_key :pictures, :boats
  end
end
