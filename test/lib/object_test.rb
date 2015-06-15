require "test_helper"
require "levelup/object"

include LevelUp::Object

describe Error do
  it "build" do
    error = Error.build({
      "Error_code"    => 42,
      "Error_message" => "message"
    })
    error.code.must_equal 42
    error.message.must_equal "message"
    error.to_s.must_equal "Error 42: message"
  end
end

describe Boolean do
  it "0 gives true" do
    a = Boolean.build({
      "Error_code"  => 0
    })
    a.must_equal true
  end


  it "1 gives true" do
    a = Boolean.build({
      "Error_code" => 1
    })
    a.must_equal true
  end


  it "2 gives false" do
    a = Boolean.build({
      "Error_code" => 2
    })
    a.must_equal false
  end
end

describe SessionToken do
  it "build" do
    session_token = SessionToken.build({
      "Session_token" => "token"
    })
    session_token.must_equal "token"
  end
end

describe Version do
  it "build" do
    version = Version.build({
      "Version" => 42
    })
    version.must_equal 42
  end
end

describe Item do
  it "build" do
    item = Item.build({
      "Infos"=>{
        "Uid"=>2,
        "Name"=>"Shampooing",
        "CurrentStock"=>0,
        "NbUsers"=>2,
        "StockoutDate"=>"0001-01-01T00:00:00Z",
        "ReminderHour"=>14,
        "ReminderInterval"=>1,
        "Standby"=>false,
        "Unit"=>"mL"
      }
    })
    item.must_be_instance_of Item
    item.id.must_equal 2
    item.name.must_equal "Shampooing"
    item.stock.must_equal 0
    item.nb_users.must_equal 2
    item.stockout_at.must_equal Date.new(1, 1, 1)
    item.remind_at.must_equal 14
    item.reminder_interval.must_equal 1
    item.standby.must_equal false
    item.unit.must_equal "mL"
  end

  it "build array" do
    items = Item.build({
      "Items"=>[{
        "Uid"=>2,
        "Name"=>"Shampooing",
        "CurrentStock"=>0,
        "NbUsers"=>2,
        "StockoutDate"=>"0001-01-01T00:00:00Z",
        "ReminderHour"=>14,
        "ReminderInterval"=>1,
        "Standby"=>false,
        "Unit"=>"mL"
      },
      {
        "Uid"=>4,
        "Name"=>"Chaussettes",
        "CurrentStock"=>0,
        "NbUsers"=>1,
        "StockoutDate"=>"0001-01-01T00:00:00Z",
        "ReminderHour"=>14,
        "ReminderInterval"=>1,
        "Standby"=>false,
        "Unit"=>"paire(s)"
      }]
    })
    items.must_be_instance_of Array
    items.map { |i| i.must_be_instance_of Item }
  end

  describe EstimatedDate do
    it "build" do
      date = EstimatedDate.build({
        "Estimated_date" => "2013-10-01 22:15:00 -0400 EDT"
      })
      date.must_equal DateTime.new(2013, 10, 1, 22, 15, 0, '-4')
    end
  end
end
