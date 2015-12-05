class BookingsController < ApplicationController
  load_and_authorize_resource :boat
  load_and_authorize_resource :booking, through: :boat
  skip_load_and_authorize_resource :booking, only: :my_bookings
  before_action :authenticate_user!
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :accept, :reject, :cancel, :reply]
  before_action :set_boat, except: :my_bookings
  before_action :get_mailbox
  before_action :get_conversation, only: [:show, :reply]

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = @boat.bookings
  end

  def my_bookings
    # authorize! :index_my_bookings, @bookings
    @bookings = current_user.bookings
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
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
        @booking.cancel!
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
    flash[:success] = _('Reply sent')
    redirect_to boat_booking_path(@boat, @booking)
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = @boat.bookings.build(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to boat_booking_path(@boat, @booking), notice: _("You have successfully requested a booking to #{@boat.user.name}") }
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
end
