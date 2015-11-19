class DaysController < ApplicationController
  load_and_authorize_resource :boat
  load_and_authorize_resource :day, through: :boat
  before_action :set_boat

  def index
    @days = @boat.days.inject({}) { |acc,d| acc[d.date.to_s] = {availability: d.availability, id: d.id}; acc }
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
