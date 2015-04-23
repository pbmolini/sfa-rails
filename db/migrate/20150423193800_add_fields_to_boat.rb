class AddFieldsToBoat < ActiveRecord::Migration
  def change
    add_column :boats, :description, :text
    add_column :boats, :fuel_type, :string
    add_column :boats, :with_license, :boolean, default: false
    add_column :boats, :rental_type, :string
    add_column :boats, :address, :string
    add_column :boats, :horse_power, :integer
  end
end
