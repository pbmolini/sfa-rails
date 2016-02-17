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
        # Mark days as "accepted"
        toggle_calendar_days aasm_state
        # Add an automatic message to the conversation
        # conversation = boat.user.mailbox.conversations.find_by booking_id: id
        boat.user.reply_with_booking_state_change(conversation, self)
        # Mail to guest
        BookingStateMailer.send_email(user, self, aasm_state, I18n.locale.to_s).deliver_later
        # Mail to host
        BookingStateMailer.send_email(boat.user, self, aasm_state, I18n.locale.to_s).deliver_later
      end
      transitions from: :pending, to: :accepted
    end

    event :reject do
      after do
        toggle_calendar_days aasm_state
        # Add an automatic message to the conversation
        # conversation = boat.user.mailbox.conversations.find_by booking_id: id
        boat.user.reply_with_booking_state_change(conversation, self)
        # TODO: send a sad email
        # Mail to guest
        BookingStateMailer.send_email(user, self, aasm_state, I18n.locale.to_s).deliver_later
        # Mail to host
        BookingStateMailer.send_email(boat.user, self, aasm_state, I18n.locale.to_s).deliver_later
      end
      transitions from: :pending, to: :rejected
    end

    event :cancel do
      after do
        # TODO: write_cancel_motivation
        toggle_calendar_days aasm_state
        # Add an automatic message to the conversation
        # conversation = boat.user.mailbox.conversations.find_by booking_id: id
        boat.user.reply_with_booking_state_change(conversation, self)
        # TODO: send a wroth email
        # Mail to guest
        BookingStateMailer.send_email(user, self, aasm_state, I18n.locale.to_s).deliver_later
        # Mail to host
        BookingStateMailer.send_email(boat.user, self, aasm_state, I18n.locale.to_s).deliver_later
      end
      transitions from: :accepted, to: :canceled, after: ->(canceled_by, reason) { update(canceled_by: canceled_by, cancellation_reason: reason) }
    end
  end
  # State Machine definition ends

  belongs_to :user
  belongs_to :boat

  has_many :days, dependent: :destroy
  has_one :conversation, class_name: "Conversation", dependent: :destroy

  belongs_to :canceled_by, class_name: "User"

  has_one :guest_review, -> (booking) { where reviewer_id: booking.user }, class_name: "Review"
  has_one :host_review, -> (booking) { where reviewer_id: booking.boat.user.id }, class_name: "Review"

  validate :minimum_booking_period, on: :create # because we can change the aasm_state even if the booking is in the past
  validate :start_before_end, on: :create
  validate :availability_of_days
  validates_numericality_of :people_on_board, greater_than_or_equal_to: 1
  validates_numericality_of :people_on_board, less_than_or_equal_to: ->(booking) {booking.boat.guest_capacity}
  validates :cancellation_reason, length: { minimum: 50 }, allow_blank: true

  after_commit :init_days, on: :create

  # Not used by aasm, but useful for the views
  STATES = [:pending, :accepted, :rejected, :canceled].freeze

  def duration_in_days
    duration_in_seconds = end_time - start_time
    (duration_in_seconds.to_i / (24 * 60 * 60)) + 1
  end

  def first_day_in_locale
    I18n.l(start_time.in_time_zone.to_date, format: :sfa_short)
  end

  def last_day_in_locale
    I18n.l(end_time.in_time_zone.to_date, format: :sfa_short)
  end

  def total_price
    duration_in_days * boat.daily_price
  end

  def title
    if duration_in_days > 1
      _("%{duration} days from %{first_day} to %{last_day}" %{duration: duration_in_days, first_day: first_day_in_locale, last_day: last_day_in_locale})
    else
      _("One day on %{first_day}" %{first_day: first_day_in_locale})
    end
  end

  def has_started?
    start_time < Time.now
  end

  def has_expired?
    end_time < Time.now
  end

  # Return an array containing the reviews
  def reviews
    ([host_review] + [guest_review]).compact
  end

  private

  def minimum_booking_period
  	unless start_time > Time.zone.now
  		errors.add :start_time, s_("BookingValidationError|must be later than now")
  	end
  	# unless end_time - start_time > 4.hours DOESN'T MAKE SENSE BECAUSE WE CANNOT RESERVE A BOAT FOR LESS THAN 24 HOURS
  	# 	errors.add :end_time, "must be later than #{start_time + 4.hours}"
  	# end
  end

  # To avoid a negative duration_in_days
  def start_before_end
    if start_time > end_time
      errors.add :start_time, s_("BookingValidationError|must be before end time")
    end
  end

  def availability_of_days
    unless (start_time.to_date..end_time.to_date).all? { |d| not Day.exists?(date: d, boat_id: self.id) } #TODO this is not future proof
      errors.add :base, s_("BookingValidationError|This boat is not available in the period you selected")

    end
  end

  # after a booking is created, this creates n days in the db
  def init_days
    (start_time.to_date..end_time.to_date).each do |t|
      Day.create date: t, availability: self.aasm_state, boat: boat, booking: self
    end
  end

  # Change the :availability of the days or delete them
  def toggle_calendar_days(state)
    if state == "accepted"
      days.each { |d| d.update_attributes availability: state }
    else
      # Set day.booking_id to nil before destroying day!
      # the :delete_all nullifys foreign keys by default
      # see http://stackoverflow.com/a/8037115
      days.delete_all
    end
  end
end
