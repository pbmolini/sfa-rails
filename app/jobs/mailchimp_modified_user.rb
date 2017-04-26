class MailchimpModifiedUser < Struct.new(:user_id)
	# This works only for :first_name and :last_name
	# because MC API doesn't permit to edit the :email

	def perform
		# get the user
		user = User.find user_id

		list_id = ENV['MC_REGISTERED_USERS_LIST_ID']
		gibbon = Gibbon::Request.new
		member = gibbon.lists(list_id).members(user.mc_member_id).update(
			body: {
				email_address: user.email,
				status: "subscribed",
				merge_fields: {
					FNAME: user.first_name,
					LNAME: user.last_name
					}
				}).body

	end

	# Uncomment when debugging and check .env
	# def error(job, exception)
	# 	Delayed::Worker.logger.error exception
	# end

	# def reschedule_at(current_time, attempts)
	# 	current_time + 30.seconds
	# end

end
