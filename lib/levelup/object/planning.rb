require "levelup/form_support"
require "levelup/object/recipe"

module LevelUp::Object
  #
  # A Foodchain Planning
  #
  
  class Planning
    include LevelUp::FormSupport

    attr_accessor :days
    #
    # Builds an Array of Items from a JSON response
    # @param  response [Hash] a Hash representing the JSON response
    #
    # @return [Array] an Array of Items
    def self.build response
      planning = response["Planning"] ? response["Planning"].map {|i| new i } : []
       planning.each_with_index  do |r, index|  
        r.build_days response["Planning"][index]["Days"]
      end
    end
    
      # @private
    def build_days  json_days
      @days = json_days.map { |s| Day.new s }
    end
    
     # A list o f a Foodchain {days}
    # @attr id [Fixnum]
    # @attr userId [Fixnum]
    # @attr date [Fixnum]
  
    class Day
      attr_accessor :id,
                    :userId,
                    :date,
                    :breakfast,
                    :lunch,
                    :diner

     def self.build response
        day = response["Day"] ? response["Day"].map {|i| new i } : []
           meal.each_with_index  do |r, index|  
            r.build_breakfasts response["Day"][index]["Breakfast"]
            r.build_lunchs response["Day"][index]["Lunch"]
            r.build_diners response["Day"][index]["Diner"]
          end
      end
      # @private
      def initialize attributes
        @id               = attributes["Uid"]
        @userId        = attributes["UserID"]
        @date         = attributes["Date"]
      end
      
          # @private
    def build_breakfasts  json_breakfasts
      @breakfast = json_breakfasts.map { |s| Meal.new s }
    end
    
      # @private
    def build_lunchs  json_lunchs
      @lunchs = json_lunchs.map { |s| Meal.new s }
    end
    
      # @private
    def build_diners  json_diners
      @diner = json_diners.map { |s| Meal.new s }
    end
      
         # A list o f a Foodchain {meal}
      # @attr id [Fixnum]
      # @attr dayID [Fixnum]
      # @attr UserId [Fixnum]
      # @attr mealTime [Fixnum]
      # @attr date [Fixnum]
      class Meal
        attr_accessor :id,
                      :dayId,
                      :userId,
                      :mealTime,
                      :date,
                      :recipes
  
        # @private
        def initialize attributes
          @id               = attributes["Uid"]
          @dayId        = attributes["DayId"]
          @userId         = attributes["UserId"]
          @mealTime         = attributes["MealTime"]
          @date             = attributes["Date"]
        end
        
        def self.build response
        meal = response["Meal"] ? response["Meal"].map {|i| new i } : []
           meal.each_with_index  do |r, index|  
            r.build_recipes response["Meal"][index]["Recipes"]
          end
      end
        
            # @private
        def build_recipes  json_recipes
           @recipe = json_recipes.map { |s| Recipe.new s }
         end
      end
    end
    
  end
end
