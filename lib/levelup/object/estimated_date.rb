require "date"

module LevelUp::Object
  #
  # This module parses dates estimates for DareForget
  #
  module EstimatedDate
    #
    # Extracts a DateTime from a JSON response +Estimated_date+ field
    # @param  response [Hash] JSON response
    #
    # @return [DateTime]
    def self.build response
      DateTime.parse(response["Estimated_date"])
    end
  end
end
