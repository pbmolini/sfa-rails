class BoatFeaturesSetsController < ApplicationController
  before_action :set_boat_features_set, only: [:show, :edit, :update, :destroy]

  # GET /boat_features_sets
  # GET /boat_features_sets.json
  def index
    @boat_features_sets = BoatFeaturesSet.all
  end

  # GET /boat_features_sets/1
  # GET /boat_features_sets/1.json
  def show
  end

  # GET /boat_features_sets/new
  def new
    @boat_features_set = BoatFeaturesSet.new
  end

  # GET /boat_features_sets/1/edit
  def edit
  end

  # POST /boat_features_sets
  # POST /boat_features_sets.json
  def create
    @boat_features_set = BoatFeaturesSet.new(boat_features_set_params)

    respond_to do |format|
      if @boat_features_set.save
        format.html { redirect_to @boat_features_set, notice: 'Boat features set was successfully created.' }
        format.json { render :show, status: :created, location: @boat_features_set }
      else
        format.html { render :new }
        format.json { render json: @boat_features_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boat_features_sets/1
  # PATCH/PUT /boat_features_sets/1.json
  def update
    respond_to do |format|
      if @boat_features_set.update(boat_features_set_params)
        format.html { redirect_to @boat_features_set, notice: 'Boat features set was successfully updated.' }
        format.json { render :show, status: :ok, location: @boat_features_set }
      else
        format.html { render :edit }
        format.json { render json: @boat_features_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boat_features_sets/1
  # DELETE /boat_features_sets/1.json
  def destroy
    @boat_features_set.destroy
    respond_to do |format|
      format.html { redirect_to boat_features_sets_url, notice: 'Boat features set was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_features_set
      @boat_features_set = BoatFeaturesSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_features_set_params
      params.require(:boat_features_set).permit(:boat_id, :vhf, :depth_finder)
    end
end
