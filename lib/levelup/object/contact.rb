require "levelup/form_support"

module LevelUp::Object

  #
  # A StillAlive Contact
  #
  # @attr  id [Fixnum]
  # @attr  name [String]
  # @attr  track_calls [Bool]
  # @attr  track_sms [Bool]
  # @attr  track_emails [Bool]
  # @attr  days_interval [Fixnum]
  # @attr  last_interaction [Date]
  # @attr  reminder_hour [DateTime] responds to +.hour+ and +.min+
  # @attr  standby [Bool]
  class Contact
    include LevelUp::FormSupport

    attr_accessor :id,
                  :name,
                  :track_calls,
                  :track_sms,
                  :track_emails,
                  :days_interval,
                  :last_interaction,
                  :reminder_hour,
                  :standby

    #
    # Builds an Array of Contacts from a JSON response
    # @param  response [Hash] a Hash representing the JSON response
    #
    # @return [Array] an Array of Contact
    def self.build response
      if response["Contacts"]
        response["Contacts"].map {|i| new i }
      elsif response["Infos"]
        new response["Infos"]
      end
    end

    #
    # Creates a Contact from a JSON API response
    # @param  attributes [Hash] JSON response
    def initialize attributes
      @id               = attributes["Uid"]
      @name             = attributes["Name"]
      @track_calls      = attributes["TrackCalls"]
      @track_sms        = attributes["TrackSms"]
      @track_emails     = attributes["TrackEmails"]
      @days_interval    = attributes["DaysInterval"]

      @last_interaction = Date.parse(attributes["LastInteraction"]) if attributes["LastInteraction"]

      @reminder_hour    = if attributes["ReminderHour"]
                            DateTime.now.change(hour: attributes["ReminderHour"] / 100,
                                                min:  attributes["ReminderHour"] % 100)
                          else
                            DateTime.now
                          end

      @standby          = attributes["Standby"]
    end


# @return [Date] the date of the next interaction with the Contact
    def next_interaction
      last_interaction + days_interval.days
    end
    
    # @return [Fixnum]
    #   the number of days since the last interaction with the Contact
    def days_since_last_interaction
    days_interval - ((next_interaction - Date.today)).to_i 
    #  ((Date.today - last_interaction) / 1.day).to_i
    end

    
  end
end
