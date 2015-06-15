require "test_helper"
require "levelup/spawner"

describe LevelUp::Core do
  before do
    @core = LevelUp::Spawner::Core.new
    LevelUp.config.host = @core.uri.to_s
    @client = LevelUp::Client.new
  end

  after do
    @core.teardown
  end

  it "login" do
    client = LevelUp::Client.new
    response = client.login(
      application: 1,
      email: "foo@bar.com",
      password: "validpassword"
    )
    client.session_token.must_be_instance_of String
    client.logged_in?.must_equal true
  end

  it "create_account" do
    client = LevelUp::Client.new
    client.create_account(
      application: 1,
      email: "test@email.com",
      password: "123456"
    )
    client.session_token.must_be_instance_of String
  end

  it "api_version" do
    @client.api_version.must_be_instance_of Fixnum
  end

  it "downloaded?" do
    client = LevelUp::Client.new("kTNjsXgEzgT5vK48ZWzjeYaYvpU=")
    response = client.downloaded? 1
    response.must_equal true
  end

  it "logout" do
    client = LevelUp::Client.new("CKrJyfvm4nD3FfnTWJuMkT8fWfg=")
    response = client.logout
    response.must_equal true
    client.session_token.must_be_nil
    client.logged_in?.must_equal false
  end

  it "profile" do
    client = LevelUp::Client.new("CKrJyfvm4nD3FfnTWJuMkT8fWfg=")
    response = client.profile
    response["Email"].must_be_instance_of String
  end


  it "logged in?" do
    @client.logged_in?.must_equal false
    client = LevelUp::Client.new("CKrJyfvm4nD3FfnTWJuMkT8fWfg=")
    client.logged_in?.must_equal true
  end
end
