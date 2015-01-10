require 'test_helper'

class BoatsControllerTest < ActionController::TestCase
  setup do
    @boat = boats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boat" do
    assert_difference('Boat.count') do
      post :create, boat: { boat_category_id: @boat.boat_category_id, daily_price: @boat.daily_price, guest_capacity: @boat.guest_capacity, length: @boat.length, manufacturer: @boat.manufacturer, model: @boat.model, name: @boat.name, year: @boat.year }
    end

    assert_redirected_to boat_path(assigns(:boat))
  end

  test "should show boat" do
    get :show, id: @boat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @boat
    assert_response :success
  end

  test "should update boat" do
    patch :update, id: @boat, boat: { boat_category_id: @boat.boat_category_id, daily_price: @boat.daily_price, guest_capacity: @boat.guest_capacity, length: @boat.length, manufacturer: @boat.manufacturer, model: @boat.model, name: @boat.name, year: @boat.year }
    assert_redirected_to boat_path(assigns(:boat))
  end

  test "should destroy boat" do
    assert_difference('Boat.count', -1) do
      delete :destroy, id: @boat
    end

    assert_redirected_to boats_path
  end
end
