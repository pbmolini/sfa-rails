class UserMailerPreview < ActionMailer::Preview
	def welcome_email
		UserMailer.welcome_email(User.first, "it")
	end

	def reset_password_instructions
    UserMailer.reset_password_instructions(User.first, "faketoken", {locale: "it"})
  end
end