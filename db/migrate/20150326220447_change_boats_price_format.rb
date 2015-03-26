class ChangeBoatsPriceFormat < ActiveRecord::Migration
  def change
    change_column :boats, :daily_price, :integer
  end
end
