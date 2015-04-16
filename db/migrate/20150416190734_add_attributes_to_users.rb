class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bio, :text
    add_column :users, :phone, :string
    add_column :users, :birthdate, :date
  end
end
