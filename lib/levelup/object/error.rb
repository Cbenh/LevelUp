module LevelUp::Object
  #
  # API error response
  #
  class Error < StandardError
    attr_reader :code, :message

    #
    # Creates an Error
    # @param  message [String]
    # @param  code [Fixnum]
    def initialize message, code=-1
      @code = code
      @message = message
    end

    #
    # Builds an error from an API response
    # @param  response [Hash] the full API response
    #
    # @return [Error]
    def self.build response
      new response["Error_message"], response["Error_code"]
    end

    #
    # Pretty prints an error
    #
    # @return [String] ex: +"Error 8: Le paramêtre 'source' est invalide"+
    def to_s
      "Error #{@code}: #{@message}"
    end
  end
end
