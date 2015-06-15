require "levelup/form_support"

module LevelUp::Object

  class Product
    include LevelUp::FormSupport

  
    attr_accessor :id,
                  :userid,
                  :productid,
                  :name,
                  :comment,
                  :bought,
                  :quantity,
                  :unit,
                  :category,
                  :shelfid,
                  :expire
                  
    #
    # Builds an Array of product from a JSON response
    # @param  response [Hash] a Hash representing the JSON response
    #
    # @return [Array] an Array of products
    def self.build response
       product = response["Products"] ? response["Products"].map {|i| new i } : []
    end

    #
    # Creates an Item from a JSON API response
    # @param  attributes [Hash] JSON response
    def initialize attributes
      @id                   = attributes["Uid"]
      @userid               = attributes["UserId"]
      @productid            = attributes["ProductId"]
      @name                 = attributes["Name"]
      @comment              = attributes["Comment"]
      @bought               = attributes["Bought"]
      @quantity             = attributes["Quantity"]
      @unit                 = attributes["Unit"]
      @category             = attributes["Category"]
      @shelfid              = attributes["ShelfId"]
      @expire               = attributes["Expire"]

    end
  end
end
