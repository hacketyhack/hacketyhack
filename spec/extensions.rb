#!/usr/bin/env ruby

require 'lib/extensions'

require 'spec/autorun'

describe Object, "blank?" do
  it "should return true for empty strings" do
    "".blank?.should == true
  end

  it "should return false for non empty strings" do
    "a".blank?.should == false
    ".".blank?.should == false
    "dfasfa".blank?.should == false
    "[]".blank?.should == false
    "0".blank?.should == false
  end

  it "should return false for strings composed of just spaces" do
    " ".blank?.should == false
    "  ".blank?.should == false
    "\t".blank?.should == false
    "\n".blank?.should == false
  end

  it "should return true for empty arrays" do
    [].blank?.should == true
  end

  it "should return false for non empty arrays" do
    [1, 2, 3].blank?.should == false
    [""].blank?.should == false
    [0].blank?.should == false
    [nil].blank?.should == false
  end

  it "should return true for zero" do
    0.blank?.should == true
    0.0.blank?.should == true
    Rational(0).blank?.should == true
  end

  it "should return false for non zero numbers" do
    1.blank?.should == false
    1.2.blank?.should == false
    0.0001.blank?.should == false
    (Rational(1)/100).blank?.should == false
    nan = 0.0/0.0
    nan.blank?.should == false
    inf = 1.0/0.0
    inf.blank?.should == false
  end

  it "should return true for nil and false" do
    nil.blank?.should == true
    false.blank?.should == true
  end

  it "should return true for an object with empty? returning true" do
    a = Object.new
    a.blank?.should == false
    def a.empty?; true end
    a.blank?.should == true
  end

  it "should return true for an object with no empty? " +
     "and zero? returning true" do
    a = Object.new
    a.blank?.should == false
    def a.zero?; true end
    a.blank?.should == true
  end

  # I didn't add the use case with empty? returning false and zero returning
  # true, as I'm not sure the current implementation is the best way to go
  # I will leave it undefined
end




describe Object, "#tap" do
  it "should return self" do
    obj = Object.new
    obj.tap{}.should == obj
  end
  
  it "should yield self" do
    obj = Object.new
    obj.tap do |x|
      x.should == obj
    end
  end
end

describe Object, "#try" do
  it "should do nothing and return self on an inexistend method" do
    obj = Object.new
    obj.try(:inexistend, 1, 2).should == obj
  end

  context "with no arguments" do it "should call the method if it exists" do
    obj = "123"
    obj.try :reverse!
    obj.should == "321"
  end end

  context "with more arguments" do it "should call the method if it exists" do
    obj = "123"
    obj.try :delete!, "2"
    obj.should == "13"
  end end

  it "should return the result ot the method if it exists" do
    obj = "123"
    obj.try(:delete, "2").should == "13"
    obj.should == "123"
  end
end