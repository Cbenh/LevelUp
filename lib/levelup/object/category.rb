module LevelUp::Object
  #
  # A DontPanic Category
  #
  # @attr  id [Fixnum]
  # @attr  name [String]
  class Category
    attr_accessor :id,
                  :name
    #
    # Builds an Array of Categories from a JSON API response
    # @param  response [Hash] a Hash representing the JSON response
    #
    # @return [Array] an Array of Categories
    def self.build response
      response["Categories"].map {|i| new i }
    end

    #
    # Creates an Category from a JSON API response
    # @param  attributes [Hash] JSON response
    def initialize attributes
      @id                = attributes["Uid"]
      @name              = attributes["Name"]
    end
  end
end
