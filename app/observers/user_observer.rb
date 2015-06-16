class UserObserver < ActiveRecord::Observer

  def after_create user
    UserMailer.welcome_email(user, I18n.locale.to_s).deliver_later
    #you should use deliver_later
  end

end