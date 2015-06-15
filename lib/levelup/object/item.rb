require "time"
require "levelup/form_support"

module LevelUp::Object
  #
  # A DareForget Item
  #
  # @attr id [Fixnum]
  # @attr name [String]
  # @attr stock [Fixnum]
  # @attr nb_users [Fixnum]
  # @attr stockout_at [Date]
  # @attr remind_at [DateTime] responds to +.hour+ and +.min+
  # @attr reminder_interval [Fixnum]
  # @attr standby [Bool]
  # @attr unir [String]
  # @attr AddedDate [fixnum]

  class Item
    include LevelUp::FormSupport

    attr_accessor :id,
                  :name,
                  :stock,
                  :nb_users,
                  :stockout_at,
                  :remind_at,
                  :reminder_interval,
                  :standby,
                  :unit,
                  :added_date

    #
    # Builds an Array of Items from a JSON response
    # @param  response [Hash] a Hash representing the JSON response
    #
    # @return [Array] an Array of Items
    def self.build response
      if response["Items"]
        response["Items"].map {|i| new i }
      elsif response["Infos"]
        new response["Infos"]
      end
    end

    #
    # Creates an Item from a JSON API response
    # @param  attributes [Hash] JSON response
    def initialize attributes
      @id                = attributes["Uid"]
      @name              = attributes["Name"]
      @stock             = attributes["CurrentStock"]
      @nb_users          = attributes["NbUsers"]
      @stockout_at       = Date.parse(attributes["StockoutDate"]) if attributes["StockoutDate"]
      @remind_at         = if attributes["ReminderHour"]
                            DateTime.now.change(hour: attributes["ReminderHour"] / 100,
                                                min:  attributes["ReminderHour"] % 100)
                          else
                            DateTime.now.change(hour: 14)
                          end

      @reminder_interval = attributes["ReminderInterval"] || 3
      @standby           = attributes["Standby"]
      @unit              = attributes["Unit"]
      @added_date        = Date.parse(attributes["AddedDate"]) if attributes["AddedDate"]

      @persisted         = attributes["StockoutDate"]
    end

    # @private
    def persisted?
      @persisted
    end
  end
end
