class Day < ActiveRecord::Base
  belongs_to :boat
  belongs_to :booking

  scope :from_now, -> { where('date >= ?', DateTime.now) }
  scope :future, -> { where('date > ?', DateTime.now) }
  scope :past, -> { where('date < ?', DateTime.now) }
  scope :available, -> { where booking_id: nil }

  # validate :can_be_set_unavailable
  before_destroy :check_booking_presence

  private

  def check_booking_presence
    !booking
  end
end
