require "levelup/object"

module LevelUp
  #
  # Implement Foodchain actions on {Recipe Recipe}s and {Category Categories}
  #
  module FoodChain
    include LevelUp::Object
    # @return [Array] the User's {Recipe recipe}
    def rated_recipes max
      get("foodchain/getBestRatedRecipes", Recipe,
         maxResults: max
      )
    end

    def used_recipes max
      get("foodchain/getMostUsedRecipes", Recipe,
         maxResults: max
      )
    end

    def get_planning
      get("/foodchain/getPlanning", Planning,
      :session_token)
    end

    def searchFCProduct product
      get("/foodchain/updateProductList", Boolean,
      :session_token,
      productList: product)
    end

    def sendCurrentListToMobile(product)
      get("/foodchain/sendCurrentListToMobile", Boolean,
      :session_token,
      productList: product)
    end

    def getDFProductExpiring
      get("/foodchain/getExpiringProducts", Product,
      :session_token)
    end

    def get_productlist
      get("/api/foodchain/getProductList", Product,
      :session_token)
    end

    def saveCurrentPlanning(planning)
      get("/foodchain/saveCurrentPlanning", Boolean,
      :session_token,
      planning: planning)
    end

    def getTips(planning)
      get("/foodchain/getTips", Boolean,
      :session_token,
      planning: planning)
    end

    def searchRecipe search, max
      get("/api/foodchain/searchRecipe", Recipe,
      :session_token,
      search: search,
      maxResults: max)
    end

    def getStarRecipes

    end

    def getRecipesInCategory id, max
      get("/api/foodchain/getRecipesInCategory", Recipe,
      categoryId: id,
      maxResults: max)
    end

    def getCategories
      get("/foodchain/getCategories", Category,
      :session_token)
    end

    def saveRecipe recipe
      get("/foodchain/saveRecipe", Boolean,
      :session_token,
       name: recipe.name,
       ingredients: recipe.ingredients.json,
       steps: recipe.step.json,
       prepDuration: recipe.prepduration,
       bakingDuration: recipe.bakingduration,
       difficulty: recipe.difficulty,
       authorisation: 1)
    end

    def recipe id
      get("/api/foodchain/recipe", Recipe,
       recipeId: id)
    end

    def allrecipe
      get("/api/foodchain/recipe/all", Recipe)
    end
  end
end
