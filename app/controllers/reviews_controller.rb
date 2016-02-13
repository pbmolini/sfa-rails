class ReviewsController < ApplicationController
	load_and_authorize_resource :boat
  load_and_authorize_resource :booking, through: :boat
  load_and_authorize_resource :review, through: :booking, singleton: true, except: [:index]
  before_action :authenticate_user!, except: [:index]

	before_action :set_boat, only: [:new, :create, :index]
	before_action :set_booking, only: [:new, :create]

	def index
		if @boat.present? # for boat's reviews [path: /boats/:boat_id/reviews]
			@reviews = @boat.reviews
		else # for user's reviews [path: /reviews]
			authenticate_user!
			@sent_reviews = current_user.sent_reviews
			@received_reviews = current_user.received_reviews
			@reviews = @sent_reviews + @received_reviews
		end
	end

	def new
		# Use the 'new' and not the 'build_association' because
		# the latter UPDATEs the record if it already exists
		# Anyway CanCan should not allow to get here
		if current_user == @booking.user
			@review = Review.new(booking: @booking, reviewer: @booking.user, reviewee: @boat.user)
		elsif current_user == @boat.user
			@review = Review.new(booking: @booking, reviewer: @boat.user, reviewee: @booking.user)
		else
			raise CanCan::AccessDenied.new(_("Not authorized!"), :create, Review)
		end				
	end

	def create
		# Here the 'build_association' is fine because if CanCan 
		# allows to get here it means that the record does not exist
		if current_user == @booking.user
			@review = @booking.build_guest_review(review_params)
		elsif current_user == @boat.user
			@review = @booking.build_host_review(review_params)
		else
			raise CanCan::AccessDenied.new(_("Not authorized!"), :create, Review)
		end

		respond_to do |format|
			if @review.save
				format.html { 
					redirect_to boat_booking_path(@boat, @booking), 
					notice: _("Your review has been saved. Thank you!")
				}
			else
				format.html { render :new }
			end
		end
	end

  private

  	# Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:booking_id]) if params[:booking_id]
    end

    def set_boat
      @boat = Boat.find(params[:boat_id]) if params[:boat_id]
    end

    def review_params
      params.require(:review).permit(:rating, :comment, :reviewee_id)
    end
end

