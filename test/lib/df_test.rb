require "test_helper"
require "levelup/spawner"

require "pp"

include LevelUp::Object

describe LevelUp::DareForget do
  before do
    @core = LevelUp::Spawner::Core.new
    LevelUp.config.host = @core.uri.to_s
    @client = LevelUp::Client.new("CKrJyfvm4nD3FfnTWJuMkT8fWfg=")
  end

  after do
    @core.teardown
  end

  it "followed items" do
    response = @client.followed_items
    response.must_be_instance_of Array
    response.map {|item|
      item.must_be_instance_of Item
    }
  end

  it "available items" do
    response = @client.followed_items
    response.must_be_instance_of Array
    response.map {|item|
      item.must_be_instance_of Item
    }
  end

  it "item infos" do
    response = @client.item_infos(2)
    response.must_be_instance_of Item
  end

  it "stockout estimation" do
    response = @client.stockout_estimation(2)
    response.must_be_instance_of DateTime
  end

  it "follow item" do
    item = @client.available_items.first
    item.nb_users = 1
    item.remind_at = 14
    item.reminder_interval = 1
    item.stock = 6
    response = @client.follow_item(item)
    response.must_be_instance_of DateTime
  end

  it "unfollow item" do
    response = @client.unfollow_item(4)
    response.must_equal true
  end

  it "update item" do
    item = @client.followed_items.first
    item.remind_at = 12
    response = @client.update_item(item)
    response.must_be_instance_of DateTime
  end
end
