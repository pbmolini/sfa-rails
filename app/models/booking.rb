class Booking < ActiveRecord::Base
  belongs_to :boat

  validate :minimum_booking_period
  validate :not_overlapping_other_bookings
  validates_numericality_of :people_on_board, less_than_or_equal_to: ->(booking) {booking.boat.guest_capacity}


  private

  def minimum_booking_period
  	unless start_time > Time.zone.now
  		errors.add :start_time, "must be later than now"
  	end
  	unless end_time - start_time > 4.hours
  		errors.add :end_time, "must be later than #{start_time + 4.hours}"
  	end
  end

  def not_overlapping_other_bookings
  	overlapping_bookings = 
  				Booking.where(boat_id: boat_id).where('end_time >= ? AND end_time <= ?', self.start_time, self.end_time) + 
  				Booking.where(boat_id: boat_id).where('start_time >= ? AND start_time <= ?', self.start_time, self.end_time)
  	unless overlapping_bookings.empty?
  		errors.add :start_time,  "Overlaps!!"
  		errors.add :end_time,  "Overlaps!!"
  	end
  end
end
