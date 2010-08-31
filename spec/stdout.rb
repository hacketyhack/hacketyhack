#!/usr/bin/env ruby

require 'lib/dev/stdout'

require 'spec/autorun'

# XXX: dots will be doubled because they are written also as part of the test
#      I chose to display dots so that the spec execution output looks good
describe STDOUT, "#write" do
  it "should emit the :output signal" do
    event_called = false
    conn = STDOUT.on_event :output, :any do
      event_called = true
    end
    STDOUT.write "."
    STDOUT.delete_event_connection conn
    event_called.should == true
  end

  it "should emit a signal with the correct argument" do
    event_called = false
    conn = STDOUT.on_event :output, :any do |arg|
      event_called = true
      arg.should == "."
    end
    STDOUT.write "."
    STDOUT.delete_event_connection conn
    event_called.should == true
  end

  it "should be called when using print" do
    event_called = false
    conn = STDOUT.on_event :output, :any do
      event_called = true
    end
    print "."
    STDOUT.delete_event_connection conn
    event_called.should == true
  end
end
