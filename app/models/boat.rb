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
  COMPULSORY_FIELDS = [
    :name,
    :manufacturer,
    :model,
    :year,
    :length,
    :guest_capacity,
    :fuel_type,
    :horse_power,
    :daily_price,
    :description
  ].freeze

  validates :rental_type, inclusion: { within: Boat::RENTAL_TYPES }
  validates :address, presence: true

  # Presence validations on COMPULSORY_FIELDS
  Boat::COMPULSORY_FIELDS.each do |f|
    validates f, presence: true, on: :update
  end

  # Other validations in COMPULSORY_FIELDS
  validates :year, numericality: { greater_than_or_equal_to: 1900 }, on: :update
  validates :fuel_type, inclusion: { within: Boat::FUEL_TYPES }, on: :update
  validates :horse_power, numericality: { greater_than_or_equal_to: 0 }, on: :update
  validates :daily_price, numericality: { greater_than_or_equal_to: 1 }, on: :update
  validates :pictures, presence: true, on: :update
  validate :max_pics, on: :update

  # Returns all the features that are true in self.boat_features_set
  def features
    self.boat_features_set.attributes.select { |k, v| k if v == true }.keys
  end

  def complete?
    Boat::COMPULSORY_FIELDS.map { |f| self.send(f) }.reduce {|r,e| r && e} and
    self.pictures.any? and
    self.boat_features_set.safety_equipment?
  end

  private

  # def min_pics
  #   errors.add(:base, "at least one picture needed") unless pictures.size >= 1
  # end

  def max_pics
    errors.add(:base, _("too many pictures (choose at most 10)")) unless pictures.size <= 10
  end
end
