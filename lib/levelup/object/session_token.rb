module LevelUp::Object
  #
  # This module builds a SessionToken from a JSON response.
  # It should mainly be used as an argument for {Client#get}
  #
  module SessionToken
    #
    # Extracts the session token field of a JSON response
    # @param  response [Hash]
    #
    # @return [String] the session token
    def self.build response
      response["Session_token"]
    end
  end
end
