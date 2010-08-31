#!/usr/bin/env ruby

require 'lib/enhancements'

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
    obj.freeze
    obj.try(:delete, "2").should == "13"
    obj.should == "123"
  end
end




describe String, "#ends?" do
  it "should return true if it starts with the given string" do
    "hello".starts?("he").should == true
    "hellohello".starts?("hello").should == true
  end

  it "should always return true if the given string is empty" do
    "hello".starts?("").should == true
    "".starts?("").should == true
  end

  it "should return false if it does not start with the given string" do
    "hello".starts?("ello").should == false
    " hello hello".starts?("hello").should == false
    "hello".starts?("e").should == false
    "hello".starts?("o").should == false
    "".starts?("hello").should == false
    "".starts?(" ").should == false
  end
end

describe String, "#ends?" do
  it "should return true if it starts with the given string" do
    "hello".ends?("lo").should == true
    "hellohello".ends?("hello").should == true
  end

  it "should always return true if the given string is empty" do
    "hello".ends?("").should == true
    "".ends?("").should == true
  end

  it "should return false if it does not start with the given string" do
    "hello".ends?("hell").should == false
    "hello hello ".ends?("hello").should == false
    "hello".ends?("e").should == false
    "hello".ends?("l").should == false
    "".ends?("hello").should == false
    "".ends?(" ").should == false
  end
end

describe String, "#remove" do
  it "should remove the substring equal to the argument" do
    "hello".remove("el").should == "hlo"
    "hellohello".remove("ell").should == "hohello"
    "hello".remove("l").should == "helo"
  end

  it "should rase an exception if it doesn't contain the substring" do
    lambda{"hello".remove("ello ")}.should raise_error
  end

  it "should not change the string" do
    str = "hello"
    str.remove "l"
    str.should == "hello"
    str.remove("he")
    str.should == "hello"
  end
end

describe String, "#to_slug" do
  it "should contain no characters other than lowercase alphanumeric and _" do
    # create a random string containing also a a lot of noise
    random_string = ""
    1000.times do
      random_string << rand(256).chr
    end
    random_string.to_slug.should =~ /^[a-z0-9_]*$/
  end

  it "should only return lowercase characters" do
    "heLlO".to_slug.should == "hello"
  end

  it "should only return alphanumeric characters" do
    "hello,world1!!!".to_slug.should == "helloworld1"
  end
  
  it "should transform whitespace to _" do
    "a a  a \n".to_slug.should == "a_a__a__"
  end

  it "should combine all the above correctly" do
    "Hello, World1!!!".to_slug.should == "hello_world1"
  end
end


describe String, "#rot13" do
  it "should translitarate all alphabeti ascii characters correctly" do
    str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    str.freeze
    str.rot13.should == "nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM"
  end

  it "should not change non alphabetic characters" do
    str = "1 + 2i"
    str.freeze
    str.rot13.should == "1 + 2v"
  end
end

describe String, "#rot13!" do
  it "should translitarate all alphabeti ascii characters correctly" do
    str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    str.rot13!
    str.should == "nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM"
  end

  it "should not change non alphabetic characters" do
    str = "1 + 2i"
    str.rot13!
    str.should == "1 + 2v"
  end

  it "should return the transliterated string" do
    str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    str.rot13!.should == "nopqrstuvwxyzabcdefghijklmNOPQRSTUVWXYZABCDEFGHIJKLM"
  end
end





describe Fixnum, "#ordinalize" do
  it "should return custom order for 1, 2, 3" do
    1.ordinalize.should == "1st"
    2.ordinalize.should == "2nd"
    3.ordinalize.should == "3rd"
    4.ordinalize.should == "4th"
    102.ordinalize.should == "102th"
  end
  
  it "should return the correct order for numbers > 3" do
    4.ordinalize.should == "4th"
    102.ordinalize.should == "102th"
  end
end

describe Fixnum, "#weeks" do
  it "should return the number of second in a self week" do
    1.weeks.should == 604800
    0.weeks.should == 0
    100.weeks.should == 60480000
  end
end


require 'time'
describe Time, "#calendar" do
  it "should return an easy readable string of the date" do
    Time.local(2010, 8, 27).calendar.should == "August 27th, 2010"
    Time.local(2001, 1, 1).calendar.should == "January 1st, 2001"
  end
end

describe Time, "#calendar_with_time" do
  it "should return an easy readable string of the date and time" do
    Time.local(2010, 8, 27, 15, 28).calendar_with_time.
                  should == "August 27th, 2010 at 3:28 PM"
    Time.local(2001, 1, 1, 0, 1).calendar_with_time.
                  should == "January 1st, 2001 at 12:01 AM"
  end
end

describe Time, "#time_only" do
  it "should return an easy readable string of the time" do
    Time.local(2010, 1, 1, 0, 0).time_only.should == "12:00 AM"
    Time.local(2010, 1, 1, 23, 59).time_only.should == "11:59 PM"
    Time.local(2010, 1, 1, 13, 1).time_only.should == "1:01 PM"
  end
end

describe Time, "#quick" do
  it "should return a readable short string of the date and time" do
    Time.local(2010, 8, 27, 15, 28).quick.should == "Aug 27, 2010 at 3:28pm"
    Time.local(2001, 1, 1, 0, 1).quick.should == "Jan 1, 2001 at 12:01am"
  end
end

describe Time, "#short" do
  it "should return a short string of the date and time" do
    Time.local(2010, 8, 27, 15, 28).short.should == "Aug 27"
    Time.local(2001, 1, 1, 0, 1).short.should == "Jan 1"
  end
end

describe Time, "#full" do
  it "should return a complete string of the date and time" do
    Time.local(2010, 8, 27, 15, 28).full.should == "2010-08-27 15:28:00"
    Time.local(2001, 1, 1, 0, 1, 1).full.should == "2001-01-01 00:01:01"
  end
end

describe Time, "#since" do
  def now
    Time.local(2010, 8, 27, 15, 28, 18)
  end

  it "should return friendly formatting for times less than a minute ago" do
    # zero seconds
    Time.local(2010, 8, 27, 15, 28, 18).since(now).should == "less than a minute"
    # one second
    Time.local(2010, 8, 27, 15, 28, 17).since(now).should == "less than a minute"
    # 40 seconds
    Time.local(2010, 8, 27, 15, 27, 38).since(now).should == "less than a minute"
    # 58 seconds
    Time.local(2010, 8, 27, 15, 27, 20).since(now).should == "1 minute"
  end

  context "with include_seconds" do
  it "should return friendly formatting for times less than a minute ago" do
    # zero seconds
    Time.local(2010, 8, 27, 15, 28, 18).since(now, true).should == "less than 5 seconds"
    # 4 second
    Time.local(2010, 8, 27, 15, 28, 14).since(now, true).should == "less than 5 seconds"
    # 5 second
    Time.local(2010, 8, 27, 15, 28, 13).since(now, true).should == "less than 10 seconds"
    # 9 second
    Time.local(2010, 8, 27, 15, 28, 9).since(now, true).should == "less than 10 seconds"
    # 10 second
    Time.local(2010, 8, 27, 15, 28, 8).since(now, true).should == "less than 20 seconds"
    # 19 second
    Time.local(2010, 8, 27, 15, 27, 59).since(now, true).should == "less than 20 seconds"
    # 20 second
    Time.local(2010, 8, 27, 15, 27, 58).since(now, true).should == "half a minute"
    # 39 seconds
    Time.local(2010, 8, 27, 15, 27, 39).since(now, true).should == "half a minute"
    # 40 seconds
    Time.local(2010, 8, 27, 15, 27, 38).since(now, true).should == "less than a minute"
    # 58 seconds
    Time.local(2010, 8, 27, 15, 27, 20).since(now, true).should == "less than a minute"
    # one minute
    Time.local(2010, 8, 27, 15, 27, 18).since(now, true).should == "1 minute"
  end
  end

  it "should return friendly formatting for times less than an hour ago" do
    # one minute
    Time.local(2010, 8, 27, 15, 27, 18).since(now).should == "1 minute"
    # one minute and one second
    Time.local(2010, 8, 27, 15, 27, 17).since(now).should == "1 minute"
    # about 3 minutes
    Time.local(2010, 8, 27, 15, 25, 22).since(now).should == "3 minutes"
    Time.local(2010, 8, 27, 15, 25, 16).since(now).should == "3 minutes"
    # about 45 minutes
    Time.local(2010, 8, 27, 14, 43, 22).since(now).should == "45 minutes"
    Time.local(2010, 8, 27, 14, 43, 16).since(now).should == "45 minutes"
  end

  it "should return friendly formatting for times less than a day ago" do
    # about 46 minutes
    Time.local(2010, 8, 27, 14, 42, 22).since(now).should == "about 1 hour"
    Time.local(2010, 8, 27, 14, 42, 16).since(now).should == "about 1 hour"
    # about 90 minutes
    Time.local(2010, 8, 27, 13, 58, 22).since(now).should == "about 1 hour"
    Time.local(2010, 8, 27, 13, 58, 16).since(now).should == "about 1 hour"
    # about 91 minutes
    Time.local(2010, 8, 27, 13, 57, 22).since(now).should == "about 2 hours"
    # 24 hours
    Time.local(2010, 8, 26, 15, 28, 18).since(now).should == "about 24 hours"
  end

  it "should return friendly formatting for times less than a year ago" do
    # about 24 hours and one minute
    Time.local(2010, 8, 26, 15, 27, 18).since(now).should == "1 day"
    # about 1 day and 12 hours
    Time.local(2010, 8, 26,  3, 28, 18).since(now).should == "1 day"
    # almost 2 days
    Time.local(2010, 8, 25, 15, 29, 18).since(now).should == "1 day"
    # 2 days
    Time.local(2010, 8, 25, 15, 28, 18).since(now).should == "2 days"
    # 26 days
    Time.local(2010, 8, 1, 15, 28, 18).since(now).should == "26 days"
    # 1 day less than a day
    Time.local(2009, 8, 28, 15, 28, 18).since(now).should == "364 days"
  end

  it "should return friendly formatting for times more than a year" do
    Time.local(2009, 8, 27, 15, 28, 18).since(now).should == "1 years"
    # one day less then 2 years
    Time.local(2008, 8, 28, 15, 28, 18).since(now).should == "1 years"
    # two years
    Time.local(2008, 8, 27, 15, 28, 18).since(now).should == "2 years"
  end

  it "should use Time.now by default" do
    now_time = Time.now
    Time.local(2010, 8, 25, 15, 29, 18).since(now_time).should ==
      Time.local(2010, 8, 25, 15, 29, 18).since
  end
end


describe Thread, "#new" do
  it "should execute the block argument" do
    block_called = false
    t = Thread.new do
      block_called = true
    end
    t.join
    block_called.should == true
  end
  
  it "should start a new thread" do
    another_thread = false
    topmost = Thread.current
    t = Thread.new do
      another_thread = true if Thread.current != topmost
    end
    t.join
    another_thread.should == true
  end

  it "should pass the arguments to the block" do
    Thread.new :arg1, 123 do |arg1, arg2|
      arg1.should == :arg1
      arg2.should == 123
    end
  end

  # TODO: needs shoes
  #it "should call error on exception"
end
