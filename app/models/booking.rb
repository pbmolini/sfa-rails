class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :boat

  has_many :days

  validate :minimum_booking_period
  validate :availability_of_days
  validates_numericality_of :people_on_board, less_than_or_equal_to: ->(booking) {booking.boat.guest_capacity}

  after_validation :set_days_unavailable, on: :create

  private

  def minimum_booking_period
  	unless start_time > Time.zone.now
  		errors.add :start_time, "must be later than now"
  	end
  	# unless end_time - start_time > 4.hours DOESN'T MAKE SENSE BECAUSE WE CANNOT RESERVE A BOAT FOR LESS THAN 24 HOURS
  	# 	errors.add :end_time, "must be later than #{start_time + 4.hours}"
  	# end
  end

  def availability_of_days
    unless (start_time.to_date..end_time.to_date).all? { |d| Day.exists?(date: d) and Day.find_by(date: d).booking.nil? }
      errors.add :base, "This boat is not available in the period you selected"
    end
  end

  def set_days_unavailable
    self.days = Day.where(date: start_time.to_date..end_time.to_date)
  end
end
