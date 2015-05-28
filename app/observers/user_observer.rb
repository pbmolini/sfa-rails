class UserObserver < ActiveRecord::Observer

  def after_create user
    UserMailer.welcome_email(user).deliver_later
    #you should use deliver_later
  end

end