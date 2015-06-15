# encoding: utf-8
class FoodchainController < ApplicationController
  before_filter :require_login
  # before_filter :require_foodchain
  skip_before_filter :require_login, only: [:recipe_details]
  def show
    @ratedrecipes = current_user.rated_recipes(10)
    @usedrecipes = current_user.used_recipes(10)
  end

  def generate_planning
    @ratedrecipes = current_user.rated_recipes(10)
    @usedrecipes = current_user.used_recipes(10)
    @starter = current_user.getRecipesInCategory(1,10)
    @dish = current_user.getRecipesInCategory(2,10)
    @dessert = current_user.getRecipesInCategory(3,10)
    @products = current_user.get_productlist
    @days_nb = params[:days_nb].to_f
    if !params[:recipe].nil?
      @selected_meal = current_user.recipe(params[:recipe])
    end
  end

  def recipe_details
    @recipe = current_user.recipe(params[:id])
    @ratedrecipes = current_user.rated_recipes(10)
    @usedrecipes = current_user.used_recipes(10)
  end

  def all_recipe
    @recipe = current_user.allrecipe
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
    @ratedrecipes = current_user.rated_recipes(10)
    @usedrecipes = current_user.used_recipes(10)
    @recipe = current_user.searchRecipe(params[:query], 10)
  end

end
