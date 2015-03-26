class UserMailer < ActionMailer::Base

  default from: 'hello@seaforall.com'

  def welcome_email user
    @user = user
    mail(:to => @user.email, :subject => _("Welcome to Sea for All!"))
  end

end