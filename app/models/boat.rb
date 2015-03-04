class Boat < ActiveRecord::Base

  belongs_to :boat_category
  has_many :bookings
  has_many :pictures, dependent: :destroy
  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

	validates :name, :manufacturer, :daily_price, :year, :model, :length, :guest_capacity, :boat_category, presence: true
	validates :year, numericality: { greater_than_or_equal_to: 1900 }
	validates :daily_price, numericality: { greater_than_or_equal_to: 1 }
	validates :pictures, presence: true

  # validate :min_pics
  validate :max_pics

  private

  # def min_pics
  #   errors.add(:base, "at least one picture needed") unless pictures.size >= 1
  # end

  def max_pics
    errors.add(:base, "too many pictures (choose at most 10)") unless pictures.size <= 10
  end
end
