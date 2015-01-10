require 'test_helper'

class BoatFeaturesControllerTest < ActionController::TestCase
  setup do
    @boat_feature = boat_features(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boat_features)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boat_feature" do
    assert_difference('BoatFeature.count') do
      post :create, boat_feature: { boat_category_id: @boat_feature.boat_category_id, name: @boat_feature.name }
    end

    assert_redirected_to boat_feature_path(assigns(:boat_feature))
  end

  test "should show boat_feature" do
    get :show, id: @boat_feature
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @boat_feature
    assert_response :success
  end

  test "should update boat_feature" do
    patch :update, id: @boat_feature, boat_feature: { boat_category_id: @boat_feature.boat_category_id, name: @boat_feature.name }
    assert_redirected_to boat_feature_path(assigns(:boat_feature))
  end

  test "should destroy boat_feature" do
    assert_difference('BoatFeature.count', -1) do
      delete :destroy, id: @boat_feature
    end

    assert_redirected_to boat_features_path
  end
end
