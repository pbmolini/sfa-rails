class AddAasmStateToBookings < ActiveRecord::Migration
  def self.up
    add_column :bookings, :aasm_state, :string
  end

  def self.down
    remove_column :bookings, :aasm_state
  end
end
