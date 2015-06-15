require "time"
require "levelup/form_support"

module LevelUp::Object
  #
  # A Profile User
  #
  # @attr id [Fixnum]
  # @attr email [String]
  # @attr newPassword [String]
  # @attr pseudo [String]
  # @attr gender [Fixnum]
  # @attr birthDate [String]
  # @attr avatar [String]


  class Profile
    include LevelUp::FormSupport

    attr_accessor :email,
                  :new_password,
                  :pseudo,
                  :gender,
                  :birth_date,
                  :avatar
                  
                      #
    # Builds an Array of profile from a JSON response
    # @param  response [Hash] a Hash representing the JSON response
    #
    # @return [Array] an Array of information
        def self.build response
        profile = new response

      end

    #
    # Creates a Profile from a JSON API response
    # @param  attributes [Hash] JSON response
    def initialize attributes
      @email              = attributes["Email"]
      @new_passwword      = attributes["NewPasswword"]
      @pseudo             = attributes["Pseudo"]
      @gender             = attributes["Gender"]
      @birth_date         = attributes["BirthDate"]
      @avatar             = attributes["Avatar"]
    end
    
  end
end
