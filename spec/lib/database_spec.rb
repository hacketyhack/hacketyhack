require_relative '../../lib/database'

# This is silly. Ideally we shouldn't need this, but our
# require-ing is a total mess, so...
module HH
  USER = "~"
end

describe HH::Database do
  context ".save" do
    it "inserts on each new key" do
      data = {:key => :value}
      db = HH::Database.new(double(:execute => []))
      db.save("names", data)
    end
  end

  context ".load" do
    it "returns a proper hash" do
      db = HH::Database.new(double(:execute => [{"key" => "key", "value" => "value"}]))

      db.load("names").should  eql({:key => "value"})
    end
  end
end
