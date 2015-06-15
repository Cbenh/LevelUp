module LevelUp::Object
  #
  # This module builds a Boolean from a JSON response.
  # It should mainly be used as an argument for {LevelUp::Client#get}
  #
  module Boolean
    #
    # Builds a Boolean from a JSON response
    # @param response [Hash] parsed JSON response
    #
    # @return [Boolean]
    #
    # @note the API implements Boolean as errors. Error codes +0+ and +1+ are parsed as +true+, +2+ as +false+.
    def self.build response
      if [0, 1].include?(response["Error_code"])
        true
      else
        false
      end
    end
  end
end
