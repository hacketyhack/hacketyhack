#!/usr/bin/env ruby

require 'lib/dev/events'

require 'spec/autorun'


describe HH::EventConnection, "#event" do
  it "should return the correct value" do
    ec = HH::EventConnection.new(:my_event, :any)
    ec.event.should == :my_event
  end
end

describe HH::EventConnection, "#try" do
  # auxiliary methods calls #try with arguments +args+ on a connection
  # with condition +conds+
  # it returns :successful on :unsuccessful
  def try(conds, args)
    result = :unsuccessful
    conn = HH::EventConnection.new(:my_event, conds) do
      result = :successful
    end
    conn.try args
    result
  end

  it "should not succeed with condition of wrong size" do
    try([], [1]).should == :unsuccessful
    try([1], []).should == :unsuccessful
    try([1, 1], [1]).should == :unsuccessful
    try([1], [1, 1]).should == :unsuccessful
  end

  it "should succeed with no conditions" do
    try([], []).should == :successful
  end

  it "should succeed with one correct condition" do
    try([String], ["str"]).should == :successful
    try([nil], [nil]).should == :successful
    try([/^\d$/], ["4"]).should == :successful
  end
  
  it "should succeed with the :any condition" do
    try([:any], [[1,2,3]]).should == :successful
  end

  it "should not succeed with one wrong condition" do
    try([String], [4]).should == :unsuccessful
    try([nil], [false]).should == :unsuccessful
    try([/^\d$/], ["44"]).should == :unsuccessful
    try([[1,2,3]], [:any]).should == :unsuccessful
  end

  it "should succeed with multiple correct conditions" do
    cond = [String, nil, /^\d$/, :any]
    args = ["str", nil, "4", [1, 2, 3]]
    try(cond, args).should == :successful
  end

  it "should not succeed if at least one condition is wrong" do
    cond = [Numeric, nil, /^\d$/, :any]
    args = ["str", nil, "4", [1, 2, 3]]
    try(cond, args).should == :unsuccessful
    cond = [String, nil, /^\d$/, :wrong]
    try(cond, args).should == :unsuccessful
  end

  context "using hash arguments" do
    def try cond, args
      super [cond], [args]
    end

    it "should succeed with no conditions" do
      try({}, {}).should == :successful
      try({}, {:a => 1, :b => 2}).should == :successful
    end

    it "should not succeed if the argument isn't an hash" do
      no_hash = []
      cond = {:a => nil, :something => 1234}
      try(cond, no_hash).should == :unsuccessful
      try({}, no_hash).should == :unsuccessful
    end

    it "should succeed with one correct condition" do
      try({:first => String}, {:first => "str"}).should == :successful
      try({:a => nil}, {:a => nil}).should == :successful
      try({:str => /^\d$/}, {:str => "4"}).should == :successful
    end

    it "should not succeed with one wrong condition" do
      try({:first => String}, {:first => 5}).should == :unsuccessful
      try({:a => nil}, {:a => ""}).should == :unsuccessful
      try({:str => /^\d$/}, {:str => "44"}).should == :unsuccessful
    end

    it "should succeed with multiple correct conditions" do
      cond = {:a => String, :b => nil, :c => /^\d$/}
      args = {:a => "str", :b => nil, :c => "4", :d => [1, 2, 3]}
      try(cond, args).should == :successful
    end

    it "should not succeed with at least one wrong condition" do
      cond = {:a => Numeric, :b => nil, :c => /^\d$/}
      args = {:a => "str", :b => nil, :c => "4", :d => [1, 2, 3]}
      try(cond, args).should == :unsuccessful
      cond = {:a => String, :b => nil, :c => /^\d$/, :wrong => Array}
      try(cond, args).should == :unsuccessful
    end
  end
end




describe HH::Observable, "#emit and #on_event" do
  it "should work when there are no connections for an event" do
    obj = Object.new
    obj.extend HH::Observable
    obj.emit :my_event, "arg1", :arg2
    obj.emit :another_event, {:arg1 => "str", :arg2 => :sym}
  end

  it "should call try on all and only the correct connections" do
    obj = Object.new
    obj.extend HH::Observable

    conn1_called = conn2_called = conn3_called = 0
    obj.on_event :event1 do
      conn1_called += 1
    end
    obj.on_event :event1, String do
      conn2_called += 1
    end
    obj.on_event :event2 do
      conne3_called += 1
    end
    obj.emit :event1 # conn1
    obj.emit :event1 # conn1
    obj.emit :event1 # conn1
    obj.emit :event1, 123 # no connection
    obj.emit :event1, 123 # no connection
    obj.emit :event1, "str" # conn 2
    conn1_called.should == 3
    conn2_called.should == 1
    conn3_called.should == 0
  end
end

describe HH::Observable, "#delete_event_connection" do
  it "should delete the event connection" do
    obj = Object.new
    obj.extend HH::Observable

    conn1_called = conn2_called = conn3_called = 0
    obj.on_event :event1 do
      conn1_called += 1
    end
    conn2 = obj.on_event :event1, String do
      conn2_called += 1
    end
    obj.on_event :event2 do
      conne3_called += 1
    end
    obj.delete_event_connection conn2
    obj.emit :event1 # conn1
    obj.emit :event1 # conn1
    obj.emit :event1 # conn1
    obj.emit :event1, 123 # no connection
    obj.emit :event1, 123 # no connection
    obj.emit :event1, "str" # conn 2
    conn1_called.should == 3
    conn2_called.should == 0 # never called because deleted
    conn3_called.should == 0
  end
end

###### the following tests test the implementation so may be changed #####
#describe HH::EventConnection, "::match_hash?" do
#  def call cond, hash
#    HH::EventConnection.match_hash? cond, hash
#  end
#
#  it "should return true with an empty condition" do
#    empty_cond = {}
#    call(empty_cond, {}).should == true
#    call(empty_cond, {:something => 123, [] => nil}).should == true
#  end
#
#  it "should return true with one correct condition" do
#    call({:first => String}, {:first => "str"}).should == true
#    call({:a => nil}, {:a => nil}).should == true
#    call({:str => /^\d$/}, {:str => "4"}).should == true
#  end
#
#  it "should return false with one wrong condition" do
#    call({:first => String}, {:first => 5}).should == false
#    call({:a => nil}, {:a => ""}).should == false
#    call({:str => /^\d$/}, {:str => "44"}).should == false
#  end
#
#  it "should return false if the argument isn't a hash" do
#    no_hash = []
#    cond = {nil => nil, :something => 1234}
#    call(cond, no_hash).should == false
#    call({}, no_hash).should == false
#  end
#
#  it "should raise an ArgumentError if the condition isn't a hash" do
#    cond = [] # no hash
#    lambda {call(cond, [])}.should raise_error(ArgumentError)
#    lambda {call(cond, :something)}.should raise_error(ArgumentError)
#  end
#end

