class AddCompleteToBoats < ActiveRecord::Migration
  def change
    add_column :boats, :complete, :boolean, default: false
  end
end
