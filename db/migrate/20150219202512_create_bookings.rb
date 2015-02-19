class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :people_on_board
      t.references :boat, index: true

      t.timestamps null: false
    end
    add_foreign_key :bookings, :boats
  end
end
