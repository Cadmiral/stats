require 'test_helper'

class TodaysGamesControllerTest < ActionController::TestCase
  setup do
    @todays_game = todays_games(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:todays_games)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create todays_game" do
    assert_difference('TodaysGame.count') do
      post :create, todays_game: {  }
    end

    assert_redirected_to todays_game_path(assigns(:todays_game))
  end

  test "should show todays_game" do
    get :show, id: @todays_game
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @todays_game
    assert_response :success
  end

  test "should update todays_game" do
    patch :update, id: @todays_game, todays_game: {  }
    assert_redirected_to todays_game_path(assigns(:todays_game))
  end

  test "should destroy todays_game" do
    assert_difference('TodaysGame.count', -1) do
      delete :destroy, id: @todays_game
    end

    assert_redirected_to todays_games_path
  end
end
