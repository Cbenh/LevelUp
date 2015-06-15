module LevelUp::Object
  #
  # This module builds a Version from a JSON response.
  # It should mainly be used as an argument for {LevelUp::Client.get}
  #
  module Version
    #
    # Extracts the version field of a JSON response
    # @param  response [Hash]
    #
    # @return [Fixnum] the version of the API used by the core
    def self.build response
      response["Version"]
    end
  end
end
