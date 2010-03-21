#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe NilPoint do
  it "should need no arguments to initialize" do
    lambda{NilPoint.new}.should_not raise_error
  end
  
  it "should respond to #listing_parts with an array of empty strings" do
    NilPoint.new.listing_parts.should == ["",""]
  end
  
  it "should respond to #listing with an empty string" do
    NilPoint.new.listing.should == ""
  end
  
  it "should respond to #tidy with an empty string" do
    NilPoint.new.tidy.should == ""
  end
  
  it "should respond to #go by doing nothing" do
    NilPoint.new.should respond_to(:go)
    lambda{NilPoint.new.go}.should_not raise_error
    lambda{NilPoint.new.go(Interpreter.new)}.should_not raise_error
  end
  
  it "should respond to #points with 0" do
    NilPoint.new.points.should == 0
  end
  
end