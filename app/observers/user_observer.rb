class UserObserver < ActiveRecord::Observer

  def after_create user
    UserMailer.welcome_email(user).deliver_now
    #you should use deliver_later
  end

end