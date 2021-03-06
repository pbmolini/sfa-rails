class BoatsController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :publish, :my_boats]
  before_action :set_boat, only: [:show, :edit, :update, :destroy, :publish]

  add_breadcrumb Proc.new { |c| c.fa_icon('tachometer') }, :dashboard_path, if: :user_signed_in?

  # GET /boats
  # GET /boats.json
  def index
    if params[:search].present? and !params[:search].empty?
      @search_location = params[:search]
      @boats = Boat.complete.near(search_params, 20, unit: :km, order: 'distance').select(&:can_be_published?)
      @search_results_count = @boats.size # count doesn't work with near
      if @boats.empty?
        @boats = Boat.complete.near(search_params, 99999, unit: :km, order: 'distance').select(&:can_be_published?)
        @boats = Boat.all if @boats.empty?
      end
    else
      @boats = Boat.complete.all.select(&:can_be_published?)
    end
  end

  def my_boats
    @boats = current_user.boats.order('complete desc')
  end

  # GET /boats/1
  # GET /boats/1.json
  def show
    @booking = @boat.bookings.build(user: current_user)
    @booking.start_time = Time.zone.tomorrow + 9.hours
    @booking.end_time = Time.zone.tomorrow + 18.hours
    @booking.people_on_board = 1
    #TODO disable also booked(accepted) days
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
        format.html { redirect_to edit_boat_path(@boat), notice: _("Boat was successfully created") }
        format.json { render :edit, status: :created, location: @boat }
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
        format.html { redirect_to @boat, notice: _("Boat was successfully updated") }
        format.js
        format.json { render :show, status: :ok, location: @boat }
      else
        format.html { render :edit }
        format.js
        format.json { render json: @boat.errors, status: :unprocessable_entity }
      end
    end
  end

  def publish
    @boat.complete = true
    # :complete is set to true so that the validations run. It is again set to
    # the real value in the model's 'after_validation'
    respond_to do |format|
      if @boat.save
        # after having saved, the boat must be :complete to be published
        if @boat.complete?
          # TODO: mandare mail per avvenuta pubblicazione
          format.html { redirect_to @boat,
            notice: _('Yay! You published your boat! Prepare to share it!')
          }
        else
          format.html { redirect_to edit_boat_path(@boat),
            alert: _("Ops! Cannot publish this boat yet: please check all the compulsory fields")
          }
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /boats/1
  # DELETE /boats/1.json
  def destroy
    @boat.destroy
    respond_to do |format|
      format.html { redirect_to boats_url, notice: _("Boat was successfully destroyed") }
      format.json { head :no_content }
    end
  end

  def dates_to_disable
    dates_to_disable = @boat.days.from_now.order('date ASC')
    respond_to do |format|
      format.json { render json: dates_to_disable }
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

  def search_params
    if params[:latitude].empty? or params[:longitude].empty?
      params[:search]
    else
      [params[:latitude], params[:longitude]]
    end
  end

end
