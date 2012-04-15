require_relative '../../lib/database'

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
      db = HH::Database.new(double(:execute => [ ["key1", "value1"], ["key2", "value2"] ]))

      db.load("names").should  eql({:key1 => "value1", :key2 => "value2"})
    end
  end
end
