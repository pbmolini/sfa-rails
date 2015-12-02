class Booking < ActiveRecord::Base
  
  # State Machine definition begins
  include AASM
  aasm do
    state :pending, initial: true
    state :accepted
    state :rejected
    state :canceled

    event :accept do
      after do
        # TODO: turn_calendar_days_red
        # TODO: send a merry email
      end
      transitions from: :pending, to: :accepted
    end

    event :reject do
      after do
        # TODO: send a sad email
      end
      transitions from: :pending, to: :rejected
    end

    event :cancel do
      after do
        # TODO: write_cancel_motivation
        # TODO: turn_calendar_days_white
        # TODO: send a wroth email
      end
      transitions from: :accepted, to: :canceled
    end
  end
  # State Machine definition ends

  belongs_to :user
  belongs_to :boat

  has_many :days

  validate :minimum_booking_period, on: :create # because we can change the aasm_state even if the booking is in the past
  validate :availability_of_days
  validates_numericality_of :people_on_board, greater_than_or_equal_to: 1
  validates_numericality_of :people_on_board, less_than_or_equal_to: ->(booking) {booking.boat.guest_capacity}

  after_validation :set_days_unavailable, on: :create

  private

  def minimum_booking_period
  	unless start_time > Time.zone.now
  		errors.add :start_time, s_("BookingValidationError|must be later than now")
  	end
  	# unless end_time - start_time > 4.hours DOESN'T MAKE SENSE BECAUSE WE CANNOT RESERVE A BOAT FOR LESS THAN 24 HOURS
  	# 	errors.add :end_time, "must be later than #{start_time + 4.hours}"
  	# end
  end

  def availability_of_days
    unless (start_time.to_date..end_time.to_date).all? { |d| not Day.exists?(date: d, boat_id: self.id) } #TODO this is not future proof
      errors.add :base, s_("BookingValidationError|This boat is not available in the period you selected")

    end
  end

  def set_days_unavailable
    self.days = Day.where(date: start_time.to_date..end_time.to_date)
  end
end
