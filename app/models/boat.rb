class Boat < ActiveRecord::Base

  belongs_to :user
  belongs_to :boat_category

  has_one :boat_features_set, dependent: :destroy
  accepts_nested_attributes_for :boat_features_set, update_only: true

  has_many :bookings
  has_many :pictures#, dependent: :destroy
  accepts_nested_attributes_for :pictures, reject_if: :all_blank, allow_destroy: true

  RENTAL_TYPES = [ 'bareboat', 'captained', 'both' ].freeze
  FUEL_TYPES = [ 'petrol', 'diesel', 'mix', 'not_applicable' ].freeze
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
    validates f, presence: true, on: :update, if: -> { complete? || complete_changed? }
  end

  # Other validations in COMPULSORY_FIELDS
  validates :year, numericality: { greater_than_or_equal_to: 1900 }, on: :update, if: -> { complete? || complete_changed? }
  validates :fuel_type, inclusion: { within: Boat::FUEL_TYPES }, on: :update, if: -> { complete? || complete_changed? }
  validates :horse_power, numericality: { greater_than_or_equal_to: 0 }, on: :update, if: -> { complete? || complete_changed? }
  validates :daily_price, numericality: { greater_than_or_equal_to: 1 }, on: :update, if: -> { complete? || complete_changed? }
  validates :pictures, presence: true, on: :update, if: -> { complete? || complete_changed? }
  validate :max_pics, on: :update, if: -> { complete? || complete_changed? }

  after_validation :set_complete, on: :update

  scope :complete, -> { where complete: true }
  scope :incomplete, -> { where complete: false }

  geocoded_by :address
  after_validation :geocode, if: -> { address.present? and address_changed? }

  # Returns all the features that are true in self.boat_features_set
  def features
    self.boat_features_set.attributes.select { |k, v| k if v == true }.keys
  end

  private

  def check_complete?
    Boat::COMPULSORY_FIELDS.map { |f| self.send(f) }.reduce {|r,e| r && e} and
    self.pictures.any? and
    self.boat_features_set.safety_equipment?
  end

  def set_complete
    # update_column :complete, check_complete?
    complete = check_complete?
  end

  # def min_pics
  #   errors.add(:base, "at least one picture needed") unless pictures.size >= 1
  # end

  def max_pics
    errors.add(:base, _("too many pictures (choose at most 10)")) unless pictures.size <= 10
  end
end
