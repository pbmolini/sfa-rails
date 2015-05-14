class PicturesController < ApplicationController
  protect_from_forgery :except => :create

  load_and_authorize_resource :boat
  load_and_authorize_resource through: :boat

	before_action :set_boat
	before_action :set_picture, only: [:destroy]

	# Maybe reusable for rendering a partial
	def index
		@pictures = @boat.pictures
	end

  def new
    @picture = @boat.pictures.build
  end

  def create
    @picture = @boat.pictures.build(picture_params)
    if @picture.save
      render json: { message: "success" }, :status => 200
    else
      #  you need to send an error header, otherwise Dropzone
          #  will not interpret the response as an error:
      render json: { error: @picture.errors.full_messages.join(',')}, :status => 400
    end
  end

	def destroy
		@picture.destroy
		respond_to do |format|
      format.html { redirect_to boat_url(@boat), notice: 'Picture was successfully destroyed.' }
      format.json { render json: { message: "Picture was successfully destroyed.", status: 200 } }
    end
	end

	private

  def picture_params
    params.require(:picture).permit(:image)
  end

	def set_picture
		@picture = Picture.find(params[:id])
	end

	def set_boat
    @boat = Boat.find(params[:boat_id])
  end
end
