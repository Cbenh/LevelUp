require 'net/http'
require 'json'
require 'levelup/object'
require 'levelup/core'
require 'levelup/dareforget'
require 'levelup/dontpanic'
require 'levelup/stillalive'
require 'levelup/foodchain'
require "erb"
require 'pp'

module LevelUp
  # The class that allows access to the API
  class Client

    # The Client's session token
    attr_reader :session_token
    include ERB::Util
    include Core
    include DareForget
    include DontPanic
    include StillAlive
    include FoodChain
    #
    # Creates a Client
    # @param  session_token [String] (optional)
    #   Allows to create an already logged in client
    def initialize session_token=nil
      @session_token = session_token
    end

    #
    # Performs a GET request on an path of the API endpoint
    # @param  path [String] the path to query
    # @param  type [Object] the type of object expected
    #   The response will be parsed by {#parse_response}
    # @param  params [Array] the parameters of the query
    #   The params will be merged and default values will be set by {#params_hash}
    #
    # @return [Object] the parsed result of the JSON response
    #
    # @example
    #   client = LevelUp::Client.new
    #   client.get("core/currentApiVersion", Fixnum) # request without parameters
    #   client.get("core/createAccount", LevelUp::SessionToken,
    #     :magic,  # `magicnum` will be set to a magic number
    #     :source, # `source` will be set to the default
    #     :plop,   # `plop` wil be discarded
    #     application: 1,
    #     email: "test@email.com",
    #     password: "123456"
    #   )
    def get path, type, *params
        puts url_encode("path : #{path}")
      uri = URI.join(LevelUp.config.host, path)
      params = params_hash params

      puts "GET #{uri}"
      pp params

      uri.query = query_string(params)
  
      response = JSON.parse(Net::HTTP.get(uri))

      pp response

      parse_response response, type
    end

    #
    # Generates a HTTP query string from a Hash
    # @param  params [Hash]
    #
    # @return [String]
    def query_string params={}
      params.map do |key, value|
        [key, url_encode(value)].join("=")
      end.join("&")
    end

    #
    # Builds a Hash of params from an Array of Symbols and Hashes
    # @param  params [Array]
    #   The following special Symbols will have their values set automatically
    #   * +:magic+:  a magic number will be generated
    #   * +:source+: {LevelUp::Configuration#source LevelUp.config.source} will be used
    #   Hashes will be merged
    #   Any other value will be discarded
    #
    # @return [Hash]
    def params_hash params
      params.reduce({}) do |hash, param|
        case param
        when Hash
          hash.merge! param
        when :magic
          hash.merge! magicnum: magic
        when :source
          hash.merge! source: LevelUp.config.source
        when :session_token
          hash.merge! sessionToken: @session_token
        else
          hash
        end
      end
    end

    #
    # Generates a magic number for signing API requests
    #
    # @return [Fixnum]
    def magic
      n = rand(100_000..200_000)
      n - n % 341
    end


    #
    # Parses the JSON response into the appropriate Object
    # @param  response [Hash] a Hash representing the response
    # @param  type [Object] the class of object expected, or a module allowing to build it.
    #
    # If an error code is present, the +type+ argument will be ignored an an {Error} will be returned.
    # If the response is not already an object of the requested type, the class or module must
    # implement a method +build(response)+ able parse the response.
    # See {Object} for an overview of the implemented types.
    # You can also use the type +Hash+ if you want only the JSON data.
    #
    # @return [Object] an Object representing the response
    def parse_response response, type
      if type == Boolean &&
         [0, 1, 2].include?(response["Error_code"])
        return type.build response
      end

      if response["Error_code"] != nil
        return Error.build(response)
      end

      if response.is_a? type
        return response
      end

      type.build response
    end
  end
end
