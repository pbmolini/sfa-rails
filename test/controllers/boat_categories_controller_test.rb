require 'test_helper'

class BoatCategoriesControllerTest < ActionController::TestCase
  setup do
    @boat_category = boat_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boat_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boat_category" do
    assert_difference('BoatCategory.count') do
      post :create, boat_category: { name: @boat_category.name }
    end

    assert_redirected_to boat_category_path(assigns(:boat_category))
  end

  test "should show boat_category" do
    get :show, id: @boat_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @boat_category
    assert_response :success
  end

  test "should update boat_category" do
    patch :update, id: @boat_category, boat_category: { name: @boat_category.name }
    assert_redirected_to boat_category_path(assigns(:boat_category))
  end

  test "should destroy boat_category" do
    assert_difference('BoatCategory.count', -1) do
      delete :destroy, id: @boat_category
    end

    assert_redirected_to boat_categories_path
  end
end
