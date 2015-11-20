class AddAvailabilityToDays < ActiveRecord::Migration
  def change
    add_column :days, :availability, :string
  end
end
