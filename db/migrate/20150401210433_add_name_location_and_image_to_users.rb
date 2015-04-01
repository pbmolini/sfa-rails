class AddNameLocationAndImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :location, :string

    change_table :users do |t|
      t.attachment :image
    end
  end
end
