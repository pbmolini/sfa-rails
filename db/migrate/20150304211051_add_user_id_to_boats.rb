class AddUserIdToBoats < ActiveRecord::Migration
  def change
    add_belongs_to :boats, :user

    add_index :boats, :user_id
  end
end
