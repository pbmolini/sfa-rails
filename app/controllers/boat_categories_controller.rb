class BoatCategoriesController < ApplicationController
  before_action :set_boat_category, only: [:show, :edit, :update, :destroy]

  # GET /boat_categories
  # GET /boat_categories.json
  def index
    @boat_categories = BoatCategory.all
  end

  # GET /boat_categories/1
  # GET /boat_categories/1.json
  def show
  end

  # GET /boat_categories/new
  def new
    @boat_category = BoatCategory.new
  end

  # GET /boat_categories/1/edit
  def edit
  end

  # POST /boat_categories
  # POST /boat_categories.json
  def create
    @boat_category = BoatCategory.new(boat_category_params)

    respond_to do |format|
      if @boat_category.save
        format.html { redirect_to @boat_category, notice: 'Boat category was successfully created.' }
        format.json { render :show, status: :created, location: @boat_category }
      else
        format.html { render :new }
        format.json { render json: @boat_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boat_categories/1
  # PATCH/PUT /boat_categories/1.json
  def update
    respond_to do |format|
      if @boat_category.update(boat_category_params)
        format.html { redirect_to @boat_category, notice: 'Boat category was successfully updated.' }
        format.json { render :show, status: :ok, location: @boat_category }
      else
        format.html { render :edit }
        format.json { render json: @boat_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boat_categories/1
  # DELETE /boat_categories/1.json
  def destroy
    @boat_category.destroy
    respond_to do |format|
      format.html { redirect_to boat_categories_url, notice: 'Boat category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_boat_category
      @boat_category = BoatCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def boat_category_params
      params.require(:boat_category).permit(:name)
    end
end
