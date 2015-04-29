class BoatFeaturesController < ApplicationController
  
  load_and_authorize_resource

  before_action :authenticate_user!
  before_action :set_boat_feature, only: [:show, :edit, :update, :destroy]

  # GET /boat_features
  # GET /boat_features.json
  def index
    @boat_features = BoatFeature.all
  end

  # GET /boat_features/1
  # GET /boat_features/1.json
  def show
  end

  # GET /boat_features/new
  def new
    @boat_feature = BoatFeature.new
  end

  # GET /boat_features/1/edit
  def edit
  end

  # POST /boat_features
  # POST /boat_features.json
  def create
    @boat_feature = BoatFeature.new(boat_feature_params)

    respond_to do |format|
      if @boat_feature.save
        format.html { redirect_to @boat_feature, notice: 'Boat feature was successfully created.' }
        format.json { render :show, status: :created, location: @boat_feature }
      else
        format.html { render :new }
        format.json { render json: @boat_feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boat_features/1
  # PATCH/PUT /boat_features/1.json
  def update
    respond_to do |format|
      if @boat_feature.update(boat_feature_params)
        format.html { redirect_to @boat_feature, notice: 'Boat feature was successfully updated.' }
        format.json { render :show, status: :ok, location: @boat_feature }
      else
        format.html { render :edit }
        format.json { render json: @boat_feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boat_features/1
  # DELETE /boat_features/1.json
  def destroy
    @boat_feature.destroy
    respond_to do |format|
      format.html { redirect_to boat_features_url, notice: 'Boat feature was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_feature
      @boat_feature = BoatFeature.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_feature_params
      params.require(:boat_feature).permit(:name, :boat_category_id)
    end
end
