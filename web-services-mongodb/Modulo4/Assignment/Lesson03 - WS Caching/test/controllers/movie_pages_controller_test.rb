require 'test_helper'

class MoviePagesControllerTest < ActionController::TestCase
  setup do
    @movie_page = movie_pages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movie_pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movie_page" do
    assert_difference('MoviePage.count') do
      post :create, movie_page: { title: @movie_page.title }
    end

    assert_redirected_to movie_page_path(assigns(:movie_page))
  end

  test "should show movie_page" do
    get :show, id: @movie_page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movie_page
    assert_response :success
  end

  test "should update movie_page" do
    patch :update, id: @movie_page, movie_page: { title: @movie_page.title }
    assert_redirected_to movie_page_path(assigns(:movie_page))
  end

  test "should destroy movie_page" do
    assert_difference('MoviePage.count', -1) do
      delete :destroy, id: @movie_page
    end

    assert_redirected_to movie_pages_path
  end
end
