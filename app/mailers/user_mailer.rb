class UserMailer < ActionMailer::Base

	helper :application # gives access to all helpers defined within `application_helper`.
	include Roadie::Rails::Automatic
	include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

	layout 'user_mailer'
  default from: "SeaForAll <hello@seaforall.com>"

  def welcome_email user, locale
    I18n.locale = locale.to_sym
    @user = user
    @recipient = user
    mail to: @recipient.email, subject: s_("MailTitle|Welcome to Sea for All!")
  end

end