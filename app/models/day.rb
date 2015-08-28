class Day < ActiveRecord::Base
  belongs_to :boat
  belongs_to :booking

  scope :from_now, -> { where('date >= ?', Date.today) }
  scope :future, -> { where('date > ?', Date.today) }
  scope :past, -> { where('date < ?', Date.today) }
  scope :available, -> { where booking_id: nil }
end
