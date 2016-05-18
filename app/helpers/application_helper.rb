module ApplicationHelper

	AWS_SFA_HOST = "//sfa-static.s3.amazonaws.com"

	def aws_image_path_for short_image_path
		"#{AWS_SFA_HOST}/img/#{short_image_path}"
	end

	def aws_pdf_path_for short_pdf_path
		"#{AWS_SFA_HOST}/pdf/#{short_pdf_path}"
	end

	def title page_title
		content_for :title, page_title
	end

	# Show a sub-navbar filled with breadcrumbs for navigating boat/bookings/reviews/days/etc.
	def current_user_navbar params={}
		content_for :current_user_navbar, render('shared/current_user_navbar', locals: params)
	end

	def tel_to(text)
		if text.present?
    	numbers = text.scan(/[0-9]+/).join("")
    	link_to text, "tel:#{numbers}"
    else
    	# this should never happen, but it happended on 2016-05-18
    	_("No phone provided")
    end
  end

  # This should be used like this: 
  # `SOME ACTION unless user_signed_in_and_complete?`
  def user_signed_in_and_complete?
  	user_signed_in? ? current_user.complete? : true
  end
	
end
