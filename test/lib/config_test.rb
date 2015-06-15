require 'test_helper'

describe LevelUp::Configuration do
  it "LevelUp.config" do
    test_host = "test_host"
    LevelUp.config do |c|
      c.host = test_host
    end
    LevelUp.config.host.must_equal test_host
  end
end
