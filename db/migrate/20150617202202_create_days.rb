class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.date :date, index: true
      t.belongs_to :boat, index: true
      t.belongs_to :booking, index: true

      t.timestamps null: false
    end

    add_foreign_key :days, :boats
    add_foreign_key :days, :bookings
  end
end
