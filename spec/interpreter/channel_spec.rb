require File.join(File.dirname(__FILE__), "/../spec_helper")
require 'interpreter/leaves'

include Nudge

describe "channel" do
  it "should have a 'name' attribute set at initialization"
  
  it "should raise a TypeError when the name is set to a non-string"
  
  it "should have a 'source' attribute which defaults to an empty hash"
  
  it "should allow setting the 'source' attribute as an optional param"
  
  it "should raise a TypeError when the 'source' is not set to a hash"  
  
  it "should return the result associated with 'name' from @source when asked for #value"
  
  it "should raise a TypeError if the value is not a Literal object"
end