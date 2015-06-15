# encoding: utf-8
class RecipeController < ApplicationController
  before_filter :require_login
  # before_filter :require_foodchain
  def new
  end

  def create
    @ratedrecipes = current_user.rated_recipes
    @usedrecipes = current_user.used_recipes
    @products = current_user.get_productlist
    @days_nb = params[:days_nb].to_f
  end

  def recipe_details
    @recipe = current_user.recipe(params[:id])
    @ratedrecipes = current_user.rated_recipes
    @usedrecipes = current_user.used_recipes
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipe(3)
    @recipe.assign_attributes(params[:recipe])
    response = current_user.saveRecipe(@recipe)
    unless response.is_a? StandardError
      redirect_to foodchain_path, notice: "Changements enregistrés !"
    else
      redirect_to foodchain_path, notice: "Changements foirés !"
    end
  end

  def search_recipe
    @query = params[:query]
    @recipe = current_user.searchRecipe(@query)
  end

end
