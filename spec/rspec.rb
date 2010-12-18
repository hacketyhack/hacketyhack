# a test trying to get rspec to run with Shoes

Shoes.setup do
  gem 'rspec'
end

require 'spec/autorun'

describe String, "#reverse" do
  it "should reverse the string" do
    "abcd".reverse.should == "dcba"
  end
end

# test to look if rspec with shoes is working
#describe Shoes::App, "#style" do
#  it "should have correct default values" do
#    Shoes.app do
#      style[:cap].should == nil
#      style[:strokewidth].should == 1.0
#    end
#  end
#end

# exit loop
Shoes.app do
  timer(0.01) do
    close
  end
end
