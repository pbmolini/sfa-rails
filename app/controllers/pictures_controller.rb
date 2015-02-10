class PicturesController < ApplicationController

	before_action :set_boat
	before_action :set_picture, only: [:destroy]

	# Maybe reusable for rendering a partial
	def index
		@pictures = @boat.pictures
	end

	def destroy
		@picture.destroy
		respond_to do |format|
      format.html { redirect_to boat_url(@boat), notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
	end

	private

	def set_picture
		@picture = Picture.find(params[:id])
	end

	def set_boat
    @boat = Boat.find(params[:boat_id])
  end
end
