module LevelUp::Object
  #
  # A Foofchain Recipe
  #
  # @attr id [Fixnum]
  # @attr name [String]
  # @attr color [Fixnum]
  # @attr grade [Fixnum]
  # @attr preparation [Fixnum]
  # @attr bakingTime [Fixnum]
  # @attr difficulty [Fixnum]
  # @attr imgUrl [String]
  # @attr price [Fixnum]
  # @attr used [Fixnum]
  # @attr creatorId [Fixnum]
  # @attr nbPersons [Fixnum]
  # @attr authorisation [Fixnum]
  # @attr steps [Array] the Recipe's {Step Steps}
  # @attr ingredients [Array] the Recipe's {ingredient ingredients}

  class Recipe
    attr_accessor :id,
            :name,
            :color,
            :grade,
            :preparation,
            :bakingTime,
            :difficulty,
            :imgUrl,
            :price,
            :used,
            :creatorId,
            :nbPersons,
            :authorisation,
            :steps,
            :ingredients
                  
                  

    #
    # Builds an Array of Recipes from a JSON response
    # @param  response [Hash] a Hash representing the JSON response
    #
    # @return [Array] an Array of Recipes
    def self.build response
      if response["Recipes"]
       recipe = response["Recipes"] ? response["Recipes"].map {|i| new i } : []
       recipe.each_with_index  do |r, index|  
       r.build_steps response["Recipes"][index]["Steps"]
       r.build_ingredients response["Recipes"][index]["Ingredients"]
       end 
       elsif response["Recipe"]
         recipe = new response["Recipe"]
          recipe.build_steps response["Recipe"]["Steps"]
          recipe.build_ingredients response["Recipe"]["Ingredients"]
          recipe
       end
    end

    #
    # Creates an Item from a JSON API response
    # @param  attributes [Hash] JSON response
    def initialize attributes
            @id = attributes["Uid"]
            @name = attributes["Name"]
            @color = attributes["Color"]
            @grade = attributes["Grade"]
            @preparation = attributes["preparation"]
            @prepDuration = attributes["prepDuration"]
            @bakingTime = attributes["BakingTime"]
            @difficulty = attributes["Difficulty"]
            @imgUrl = attributes["ImgUrl"]
            @price = attributes["Price"]
            @used = attributes["Used"]
            @creatorId = attributes["CreatorId"]
            @nbPersons = attributes["NbPersons"]
            @authorisation = attributes["Authorisation"]

    end

    # @private
    def build_steps  json_steps
      @steps = json_steps.map { |s| Step.new s }
    end

   # @private
    def build_ingredients json_ingredients
      @ingredients = json_ingredients.map{ |s| Ingredient.new s }
    end


  def step id
      steps[id]
    end
    
    
  def ingredient id
      ingredients[id]
    end
    
    # A Step of a Foodchain {Recipes recipe}
    # @attr id [Fixnum]
    # @attr recipeId [Fixnum]
    # @attr stepId [Fixnum]
    # @attr content [String]
    class Step
      attr_accessor :id,
                    :recipeId,
                    :stepId,
                    :content

      # @private
      def initialize attributes
        @id                = attributes["Uid"]
        @recipeId          = attributes["RecipeId"]
        @stepId            = attributes["StepId"]
        @content           = attributes["Content"]
      end
    end  
 

     # A list o f a Foodchain {ingredients}
     ## ingredients are ID : How to get their name ?
    # @attr id [Fixnum]
    # @attr productID [Fixnum]
    # @attr recipeId [Fixnum]
    # @attr quantity [Fixnum]
    # @attr unit [Fixnum]
    class Ingredient
      attr_accessor :id,
                    :productId,
                    :recipeId,
                    :quantity,
                    :unit

      # @private
      def initialize attributes
        @id               = attributes["Uid"]
        @productId        = attributes["ProductId"]
        @recipeId         = attributes["RecipeId"]
        @quantity         = attributes["Quantity"]
        @unit             = attributes["Unit"]
      end
    end
    

    
  end
end
