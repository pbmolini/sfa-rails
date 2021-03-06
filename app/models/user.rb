class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  acts_as_messageable

  has_many :boats
  has_many :bookings

  has_many :sent_reviews, class_name: "Review", foreign_key: :reviewer_id
  has_many :received_reviews, class_name: "Review", foreign_key: :reviewee_id

  has_attached_file :image, :styles => { thumb: "50x50#", medium: "150x150#" }, default_url: "default_avatar.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_presence_of :first_name, :last_name

  # These validations are skipped when the user resets the password
  validates :birthdate, presence: true, on: :update, unless: Proc.new { |u| u.encrypted_password_changed? }
  validate :at_least_16, on: :update, unless: Proc.new { |u| u.encrypted_password_changed? }
  validate :not_too_old, on: :update, unless: Proc.new { |u| u.encrypted_password_changed? }
  validates :phone, presence: true, on: :update, unless: Proc.new { |u| u.encrypted_password_changed? }
  validates :location, presence: true, on: :update, unless: Proc.new { |u| u.encrypted_password_changed? }

  # Modify record in Mailchimp
  after_commit :update_mailchimp, on: :update

  # Remove the user's email from the mailing list on Mailchimp
  after_commit :remove_from_mailchimp, on: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.location = auth.info.location
      user.image = facebook_image_url(auth.info.image)
      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        user.first_name = data["first_name"] if user.first_name.blank?
        user.last_name = data["last_name"] if user.last_name.blank?
        user.location = data["location"] if user.location.blank?
        user.image = facebook_image_url(data["image"]) if user.image.blank?
      end
    end
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def complete?
    valid?
    # self.location.present? and self.phone.present? and self.birthdate.present?
  end

  # All the bookings of all the user's boats
  def boat_bookings
    Booking.joins(:boat).merge(Boat.where(user: self))
  end

  # MAILBOXER: Used by mailboxer, see https://github.com/mailboxer/mailboxer#emails
  def mailboxer_email(object)
    email unless object.is_a? BookingStateMessage and object.is_booking_state_change?
  end

  # MAILBOXER: Reply to conversation with booking state change message
  # more coherent with Mailboxer own methods
  def reply_with_booking_state_change(conversation, booking)
    BookingStateMessage.new(self, conversation, booking).deliver
  end

  # Devise ActiveJob Integration, see https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  # Remove the user's email from the mailing list on Mailchimp
  def remove_from_mailchimp
    Delayed::Job.enqueue MailchimpDeletedUser.new mc_member_id
  end

  # Modify record in Mailchimp
  def update_mailchimp
    if previous_changes['email'].present?
      # Delete the record and create a new one
      Delayed::Job.enqueue MailchimpRecreateUser.new self.id

    end
    if previous_changes['first_name'].present? or previous_changes['last_name'].present?
      # Update only :first_name or :last_name
      Delayed::Job.enqueue MailchimpModifiedUser.new self.id
    end
  end

  def self.facebook_image_url uri
    image_url = URI.parse(uri)
    image_url.scheme = 'https'
    image_url.to_s
  end

  def at_least_16
    if birthdate
      errors.add(:birthdate, _("must be before %{date}") %{date: 16.years.ago.to_date}) unless birthdate < 16.years.ago.to_date
    end
  end

  def not_too_old
    if birthdate
      errors.add(:birthdate, _('It seems you are a bit too old...')) unless birthdate > 100.years.ago.to_date
    end
  end
end
