require 'test_helper'

class MovieActionsControllerTest < ActionController::TestCase
  setup do
    @movie_action = movie_actions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movie_actions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movie_action" do
    assert_difference('MovieAction.count') do
      post :create, movie_action: { title: @movie_action.title }
    end

    assert_redirected_to movie_action_path(assigns(:movie_action))
  end

  test "should show movie_action" do
    get :show, id: @movie_action
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movie_action
    assert_response :success
  end

  test "should update movie_action" do
    patch :update, id: @movie_action, movie_action: { title: @movie_action.title }
    assert_redirected_to movie_action_path(assigns(:movie_action))
  end

  test "should destroy movie_action" do
    assert_difference('MovieAction.count', -1) do
      delete :destroy, id: @movie_action
    end

    assert_redirected_to movie_actions_path
  end
end
