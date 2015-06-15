module LevelUp
  # Contains the global configuration for the API client.
  # See {LevelUp.config LevelUp.config}
  class Configuration
    # The URL of the core,
    # http://api.levelup-suite.com/api by default
    attr_accessor :host

    # The ID of the source,
    # +1+ (website) by default
    attr_accessor :source

    # Initializes a new Configuration object
    def initialize
      @host = "http://api-preprod.levelup-suite.com/api"
      @source = 1
    end
  end

  #
  # Global configuration for the API client
  #
  # @return [Configuration]
  #
  # @example Setting some configuration attributes
  #   LevelUp.config do |c|
  #     c.host = "http://api.levelup-suite.com/api"
  #     c.source = 1
  #   end
  def self.config
    @configuration ||= Configuration.new
    if block_given?
      yield @configuration
    else
      @configuration
    end
  end
end
