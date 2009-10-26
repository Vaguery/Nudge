require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe "Result object" do
  it "should take an obligatory 'expected' parameter when initialized" do
    lambda{Result.new}.should raise_error(ArgumentError)
    lambda{Result.new("anything")}.should_not raise_error
  end
  
  it "should take an optional 'observed' parameter" do
    lambda{Result.new(99,100)}.should_not raise_error
  end
end