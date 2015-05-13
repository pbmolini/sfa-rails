require 'test_helper'

class BoatFeaturesSetsControllerTest < ActionController::TestCase
  setup do
    @boat_features_set = boat_features_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boat_features_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boat_features_set" do
    assert_difference('BoatFeaturesSet.count') do
      post :create, boat_features_set: { boat_id: @boat_features_set.boat_id, depth_finder: @boat_features_set.depth_finder, vhf: @boat_features_set.vhf }
    end

    assert_redirected_to boat_features_set_path(assigns(:boat_features_set))
  end

  test "should show boat_features_set" do
    get :show, id: @boat_features_set
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @boat_features_set
    assert_response :success
  end

  test "should update boat_features_set" do
    patch :update, id: @boat_features_set, boat_features_set: { boat_id: @boat_features_set.boat_id, depth_finder: @boat_features_set.depth_finder, vhf: @boat_features_set.vhf }
    assert_redirected_to boat_features_set_path(assigns(:boat_features_set))
  end

  test "should destroy boat_features_set" do
    assert_difference('BoatFeaturesSet.count', -1) do
      delete :destroy, id: @boat_features_set
    end

    assert_redirected_to boat_features_sets_path
  end
end
