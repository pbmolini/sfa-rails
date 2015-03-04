class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_boat

  # GET /bookings
  # GET /bookings.json
  def index
    if @boat
      @bookings = @boat.bookings
    else
      @bookings = current_user.bookings
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = @boat.bookings.build(user: current_user)
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = @boat.bookings.build(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to @boat, notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @boat }
      else
        format.html { render 'boats/show' }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    def set_boat
      @boat = Boat.find(params[:boat_id]) if params[:boat_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:start_time, :end_time, :people_on_board, :boat_id, :user_id)
    end
end
