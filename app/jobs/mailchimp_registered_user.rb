class MailchimpRegisteredUser < Struct.new(:user_id, :first_name, :last_name, :email)

	def perform
		gibbon = Gibbon::Request.new
		gibbon.lists(ENV['MC_REGISTERED_USERS_LIST_ID']).members.create(
			body: {
				email_address: email, 
				status: "subscribed", 
				merge_fields: {FNAME: first_name, LNAME: last_name}
				})
	end

	# Uncomment when debugging
	# def error(job, exception)		
	# 	Delayed::Worker.logger.error exception.raw_body
	# end

	# def reschedule_at(current_time, attempts)
	# 	current_time + 30.seconds
	# end
end