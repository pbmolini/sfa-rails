class AddCanceledByToBookings < ActiveRecord::Migration
  def up
    add_reference :bookings, :canceled_by, references: :users, index: true
    add_foreign_key :bookings, :users, column: :canceled_by_id
  end
  def down
  	remove_column :bookings, :canceled_by_id
  end
end
