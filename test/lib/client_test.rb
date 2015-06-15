require "test_helper"
require "levelup/spawner"
require "levelup/object"

include LevelUp
include LevelUp::Object

describe Client do
  before do
    @core = LevelUp::Spawner::Core.new
    LevelUp.config.host = @core.uri.to_s
    @client = Client.new
  end

  after do
    @core.teardown
  end

  it ".query_string" do
    @client.query_string(a: 1, b: 2).must_equal "a=1&b=2"
  end

  it ".params_hash" do
    hash = @client.params_hash([
      :magic,
      :source,
      :plop,
      application: 1,
      email: "test@email.com",
      password: "123456"
    ])
    hash.must_be_instance_of Hash
    hash[:magicnum].must_be_instance_of Fixnum
    hash[:source].must_equal LevelUp.config.source
    hash[:plop].must_be_nil
    hash[:application].must_equal 1
    hash[:email].must_equal "test@email.com"
    hash[:password].must_equal "123456"
  end

  it ".get" do
    response = @client.get("core/createAccount", SessionToken,
      :magic,
      :source,
      :plop,
      application: 1,
      email: "test@email.com",
      password: "123456"
    )
    response.must_be_instance_of String
  end

  it ".get error handling" do
    response = @client.get("core/createAccount", SessionToken)
    response.must_be_instance_of Error
  end
end
