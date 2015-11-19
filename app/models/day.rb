class Day < ActiveRecord::Base
  belongs_to :boat
  belongs_to :booking

  scope :from_now, -> { where('date >= ?', DateTime.now) }
  scope :future, -> { where('date > ?', DateTime.now) }
  scope :past, -> { where('date < ?', DateTime.now) }
  # scope :available, -> { where booking_id: nil }
end
