module ApplicationHelper

	def aws_image_path_for short_image_path
		"//sfa-static.s3.amazonaws.com/img/#{short_image_path}"
	end

end
