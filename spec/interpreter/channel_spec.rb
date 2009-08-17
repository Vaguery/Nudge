require File.join(File.dirname(__FILE__), "/../spec_helper")
require 'interpreter/leaves'

include Nudge

describe "channel" do
  it "should have a 'name' attribute set at initialization" do
    b1 = Channel.new('x1')
    b1.name.should == 'x1'
  end
  
  it "should raise a TypeError when the name is set to a non-string" do
    lambda {b1 = Channel.new(false)}.should raise_error(TypeError, "Channel must have a string name")
  end
  
  it "should have a 'source' attribute which defaults to an empty hash" do
    b1 = Channel.new('myname')
    b1.source.should == {}
  end
  
  it "should allow setting the 'source' attribute as an optional param" do
    someplace = {}
    b1 = Channel.new('myname',someplace)
    b1.source.should == someplace
  end
  
  it "should raise a TypeError when the 'source' is not set to a hash" do
    not_source = ["array"]
    lambda {b1 = Channel.new('x', not_source)}.should raise_error(TypeError, "Channel source must be a hash")
  end
  
  
  it "should return the result associated with 'name' from @source when asked for #value" do
    xv = Literal.new(:string, 'foo')
    yv = Literal.new(:float, 9.12)
    aHash = {'x' => xv, 'y' => yv}
    b1 = Channel.new('x',aHash)
    b1.value.should == xv
  end
  
  it "should raise a TypeError if the value is not a Literal object" do
    badHash = {'x' => 'bad_string'}
    b1 = Channel.new('x',badHash)
    lambda {b1.value}.should raise_error(TypeError)
  end
end