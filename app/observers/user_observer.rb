class UserObserver < ActiveRecord::Observer

  def after_create user
  	# Send the welcome email
    UserMailer.welcome_email(user, I18n.locale.to_s).deliver_later

    # Add the user to the Mailchimp list, only in production and staging
    unless Rails.env == "development"
	    Delayed::Job.enqueue MailchimpRegisteredUser.new(
	    	user.id,
	    	user.first_name, 
	    	user.last_name, 
	    	user.email
	    	)
	  end
  end

end