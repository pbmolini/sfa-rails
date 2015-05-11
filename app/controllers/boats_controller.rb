class BoatsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_boat, only: [:show, :edit, :update, :destroy]

  # GET /boats
  # GET /boats.json
  def index
    @boats = Boat.all
  end

  # GET /boats/1
  # GET /boats/1.json
  def show
    @booking = @boat.bookings.build(user: current_user)
    @booking.start_time = Time.zone.tomorrow + 9.hours
    @booking.end_time = Time.zone.tomorrow + 18.hours
    @booking.people_on_board = 1
  end

  # GET /boats/new
  def new
    @boat = current_user.boats.build
    @boat.pictures.build
  end

  # GET /boats/1/edit
  def edit
  end

  # POST /boats
  # POST /boats.json
  def create
    @boat = current_user.boats.build(boat_params)
    @boat.create_boat_features_set
    respond_to do |format|
      if @boat.save
        format.html { redirect_to @boat, notice: _("Boat was successfully created.") }
        format.json { render :show, status: :created, location: @boat }
      else
        # pictures must be rebuilt to make the field appear in the form
        @boat.pictures.build unless @boat.pictures.any?
        format.html { render :new }
        format.json { render json: @boat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boats/1
  # PATCH/PUT /boats/1.json
  def update
    respond_to do |format|
      if @boat.update(boat_params)
        format.html { redirect_to @boat, notice: _("Boat was successfully updated.") }
        format.json { render :show, status: :ok, location: @boat }
      else
        format.html { render :edit }
        format.json { render json: @boat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boats/1
  # DELETE /boats/1.json
  def destroy
    @boat.destroy
    respond_to do |format|
      format.html { redirect_to boats_url, notice: _("Boat was successfully destroyed.") }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_boat
    @boat = Boat.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def boat_params
    create_params = [
      :name,
      :manufacturer,
      :daily_price,
      :year,
      :model,
      :length,
      :guest_capacity,
      :boat_category_id,
      :description,
      :fuel_type,
      :with_license,
      :rental_type,
      :address,
      :horse_power,
      pictures_attributes: [:id, :image, :_destroy]
    ]
    update_params = create_params + [ boat_features_set_attributes: [:id] + BoatFeaturesSet::FEATURES ]
    if action_name == "create"
      params.require(:boat).permit(create_params)
    elsif action_name == "update"
      params.require(:boat).permit(update_params)
    end
  end

end
