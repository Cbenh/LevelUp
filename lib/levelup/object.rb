require "levelup/object/error"
require "levelup/object/session_token"
require "levelup/object/boolean"
require "levelup/object/version"
require "levelup/object/item"
require "levelup/object/contact"
require "levelup/object/estimated_date"
require "levelup/object/tutorial"
require "levelup/object/category"
require "levelup/object/profile"
require "levelup/object/recipe"
require "levelup/object/planning"
require "levelup/object/product"

module LevelUp
  #
  # This namespace regroups the types that can be built from an API response
  # by {LevelUp::Client#parse_response}
  #
  module Object
  end
end
