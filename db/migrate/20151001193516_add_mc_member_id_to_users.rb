class AddMcMemberIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mc_member_id, :string
  end
end
