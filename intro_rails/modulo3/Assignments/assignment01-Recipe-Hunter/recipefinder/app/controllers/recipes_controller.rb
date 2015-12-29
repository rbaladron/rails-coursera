class RecipesController < ApplicationController
  def index
    @search_term = param[:search] || 'chocolate'
    @recipes = Recipe.for(@search_term)
  end
end
