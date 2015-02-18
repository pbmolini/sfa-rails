class Boat < ActiveRecord::Base

  belongs_to :boat_category
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures

	validates :name, :manufacturer, :daily_price, :year, :model, :length, :guest_capacity, :boat_category, presence: true
	validates :year, numericality: { greater_than_or_equal_to: 1900 }
	validates :daily_price, numericality: { greater_than_or_equal_to: 1 }
	validates :pictures, presence: true

end
