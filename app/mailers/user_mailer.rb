class UserMailer < Devise::Mailer

	helper :application # gives access to all helpers defined within `application_helper`.
	include Roadie::Rails::Automatic
	include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

	layout 'user_mailer'
  default from: "Sea for All <hello@seaforall.com>"

  def welcome_email user, locale
    I18n.locale = locale.to_sym
    @user = user
    @receiver = user
    mail to: @receiver.email, subject: s_("MailTitle|Welcome to Sea for All!")
  end

  # Overrides the original Devise method
  def reset_password_instructions(record, token, opts={})
    I18n.locale = opts[:locale].to_sym if opts[:locale].present?
    @receiver = record
    # must call super at the end
    super
  end

end