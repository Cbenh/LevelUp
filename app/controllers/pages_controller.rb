# encoding: utf-8
class PagesController < ApplicationController
  skip_before_filter :require_login
  def home
    @newest_tutorials = current_user.newest_tutorials(4)
    @ratedrecipes = current_user.rated_recipes(4)
  end
  
end
