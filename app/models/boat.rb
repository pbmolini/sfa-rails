class Boat < ActiveRecord::Base

  belongs_to :user
  belongs_to :boat_category

  has_one :boat_features_set, dependent: :destroy
  accepts_nested_attributes_for :boat_features_set, update_only: true

  has_many :bookings
  has_many :pictures#, dependent: :destroy
  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

  RENTAL_TYPES = [ 'bareboat', 'captained', 'both' ].freeze
  FUEL_TYPES = [ 'petrol', 'diesel', 'mix' ].freeze

  validates :name, :manufacturer, :daily_price, :year, :model, :length, :guest_capacity, :boat_category, presence: true, on: :update
  validates :year, numericality: { greater_than_or_equal_to: 1900 }, on: :update
  validates :daily_price, numericality: { greater_than_or_equal_to: 1 }, on: :update
  validates :pictures, presence: true, on: :update
  validates :description, presence: true, on: :update
  validates :fuel_type, inclusion: { within: Boat::FUEL_TYPES }, on: :update
  validates :rental_type, inclusion: { within: Boat::RENTAL_TYPES }
  validates :address, presence: true
  validates :horse_power, numericality: { greater_than_or_equal_to: 0 }, on: :update


  # validate :min_pics
  validate :max_pics, on: :update

  # Returns all the features that are true in self.boat_features_set
  def features
    self.boat_features_set.attributes.select { |k, v| k if v == true }.keys
  end

  private

  # def min_pics
  #   errors.add(:base, "at least one picture needed") unless pictures.size >= 1
  # end

  def max_pics
    errors.add(:base, _("too many pictures (choose at most 10)")) unless pictures.size <= 10
  end
end
