class DaysController < ApplicationController
  load_and_authorize_resource :boat
  load_and_authorize_resource :day, through: :boat
  before_action :set_boat

  add_breadcrumb Proc.new { |c| c.fa_icon('tachometer') }, :dashboard_path, only: [:index]

  def index
    add_breadcrumb @boat.name, boat_path(@boat)
    @days = @boat.days.inject({}) { |acc,d| acc[d.date.to_s] = {availability: d.availability, booking_id: d.booking_id, id: d.id}; acc }

    respond_to do |format|
      format.html
      format.json { render json: @days }
    end

    # @boat.bookings.each do |b|
    #   (b.start_time..b.end_time).each do |t|
    #     @boat[t.to_date.to_s] = { availability: b.state, id: ?? }
    #   end
    # end
  end

  def create
    #TODO
    @day = @boat.days.build(day_params)

    respond_to do |format|
      if @day.save
        format.json { render json: { success: true, day: @day } }
      else
        format.json { render json: { success: false } }
      end
    end
  end

  def destroy
    @day = Day.find(params[:id])
    if @day.present?
      respond_to do |format|
        if @day.destroy
          format.json { render json: { success: true } }
        else
          format.json { render json: { success: false, errors: @day.errors } }
        end
      end
    end
  end

  private

  def set_boat
    @boat = Boat.find params[:boat_id]
  end

  def day_params
    params.require(:day).permit(:date, :availability)
  end
end
