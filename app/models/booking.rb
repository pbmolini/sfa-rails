class Booking < ActiveRecord::Base
  belongs_to :boat

  validate :minimum_booking_period
  # validates :people_on_board, numericality: { less_than_or_equal_to: lambda { |n| self.boat.guest_capacity } } 
  validates_numericality_of :people_on_board, less_than_or_equal_to: ->(booking) {booking.boat.guest_capacity}
  private

  def minimum_booking_period
  	unless start_time > DateTime.now
  		errors.add :start_time, "must be later than now"
  	end
  	unless end_time - start_time > 4.hours
  		errors.add :end_time, "must be later than #{start_time + 4.hours}"
  	end
  end
end
