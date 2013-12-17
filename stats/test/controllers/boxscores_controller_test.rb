require 'test_helper'

class BoxscoresControllerTest < ActionController::TestCase
  setup do
    @boxscore = boxscores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boxscores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boxscore" do
    assert_difference('Boxscore.count') do
      post :create, boxscore: {  }
    end

    assert_redirected_to boxscore_path(assigns(:boxscore))
  end

  test "should show boxscore" do
    get :show, id: @boxscore
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @boxscore
    assert_response :success
  end

  test "should update boxscore" do
    patch :update, id: @boxscore, boxscore: {  }
    assert_redirected_to boxscore_path(assigns(:boxscore))
  end

  test "should destroy boxscore" do
    assert_difference('Boxscore.count', -1) do
      delete :destroy, id: @boxscore
    end

    assert_redirected_to boxscores_path
  end
end
