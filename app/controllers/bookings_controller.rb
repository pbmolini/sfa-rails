class BookingsController < ApplicationController
  load_and_authorize_resource :boat
  load_and_authorize_resource :booking, through: :boat, except: [:my_bookings]
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :accept, :reject, :cancel, :reply]
  before_action :set_boat, except: :my_bookings
  before_action :get_mailbox
  before_action :get_conversation, only: [:show, :reply]

  add_breadcrumb Proc.new { |c| c.fa_icon('tachometer') }, :dashboard_path, only: [:index, :show, :my_bookings]

  # GET /bookings
  # GET /bookings.json
  def index
    add_breadcrumb @boat.name, boat_path(@boat)
    @bookings = @boat.bookings.order start_time: :desc
    split_by_state @bookings
  end

  def my_bookings
    @bookings = current_user.bookings.order start_time: :desc
    @boat_bookings = current_user.boat_bookings
    Booking::STATES.each do |state|
      instance_variable_set("@#{state}_bookings", 
        current_user.bookings.send(state).order(start_time: :desc) + 
        current_user.boat_bookings.send(state).order(start_time: :desc)
        ) # this creates @pending_bookings, @accepted_bookings, etc.
    end
    # split_by_state @bookings
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    add_breadcrumb @boat.name, boat_path(@boat)
    add_breadcrumb(_("Bookings"), boat_bookings_path(@boat)) if can? :edit, @boat
    @other_user = current_user_is_guest? ? @booking.boat.user : @booking.user
    
    # The @review is used by can? for displaying the Review button
    guest_review = Review.new(reviewer: @booking.user, booking: @booking)
    host_review = Review.new(reviewer: @booking.boat.user, booking: @booking)
    @review = current_user_is_guest? ? guest_review : host_review
  end

  # GET /bookings/new
  def new
    @booking = @boat.bookings.build(user: current_user)
  end

  def accept
    respond_to do |format|
      if @booking.may_accept?
        @booking.accept!
        format.html { redirect_to boat_booking_path(@boat, @booking), notice: _("You have accepted this booking!") }
      else
        format.html { redirect_to boat_booking_path(@boat, @booking), alert: _("Oops! It was not possible to accept this booking!") }
      end
    end
  end

  def reject
    respond_to do |format|
      if @booking.may_reject?
        @booking.reject!
        format.html { redirect_to boat_booking_path(@boat, @booking), notice: _("You have rejected this booking!") }
      else
        format.html { redirect_to boat_booking_path(@boat, @booking), alert: _("Oops! It was not possible to reject this booking!") }
      end
    end
  end

  def cancel
    respond_to do |format|
      if @booking.may_cancel?
        @booking.cancel! current_user, params[:booking][:cancellation_reason]
        format.html { redirect_to boat_booking_path(@boat, @booking), notice: _("You have canceled this booking!") }
      else
        format.html { redirect_to boat_booking_path(@boat, @booking), alert: _("Oops! It was not possible to cancel this booking!") }
      end
    end
  end

  # GET /bookings/1/edit
  def edit
  end

  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    flash[:success] = _('Message sent')
    redirect_to boat_booking_path(@boat, @booking)
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = @boat.bookings.build(booking_params)

    respond_to do |format|
      if @booking.save
        format.html {
          redirect_to boat_booking_path(@boat, @booking),
                      notice: _("You have successfully requested a booking to %{host_name}") %{host_name: @boat.user.name}
        }
        # format.json { render :show, status: :created, location: @boat }
      else
        format.html { render 'boats/show' }
        # format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @boat, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @boat }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to @boat, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def get_mailbox
      @mailbox ||= current_user.mailbox
    end

    def get_conversation
      @conversation ||= @mailbox.conversations.find_by booking_id: @booking.id
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def set_boat
      @boat = Boat.find(params[:boat_id]) if params[:boat_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:boat_id)
      params.require(:booking).permit(:start_time, :end_time, :people_on_board, :user_id)
    end

    def current_user_is_guest?
      current_user == @booking.user
    end

    def split_by_state bookings
      @pending_bookings = bookings.select &:pending?
      @accepted_bookings = bookings.select &:accepted?
      @canceled_bookings = bookings.select &:canceled?
      @rejected_bookings = bookings.select &:rejected?
      
      # @expired_bookings = bookings.select &:has_expired?
      
      # @active_bookings = bookings - @expired_bookings - @canceled_bookings - @rejected_bookings
    end

end
