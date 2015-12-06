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
	
end
