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
		content_for :current_user_navbar, render('shared/current_user_navbar', params)
	end

	def tel_to(text)
    numbers = text.scan(/[0-9]+/).join("")
    link_to text, "tel:#{numbers}"
  end
	
end
