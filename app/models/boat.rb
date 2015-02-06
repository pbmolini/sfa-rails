class Boat < ActiveRecord::Base

	validates :name, :manufacturer, :daily_price, :year, :model, :length, :guest_capacity, :boat_category, presence: true
	validates :year, numericality: { greater_than: 1900 }
	validates :daily_price, numericality: { greater_than: 1 }
	
  belongs_to :boat_category
  has_many :pictures
end
