require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "channel" do
  it "should have a name parameter with no default" do
    myC = Channel.new("x")
    myC.should be_a_kind_of(Channel)
    myC.name.should == "x"
    lambda {Channel.new()}.should raise_error(ArgumentError)
  end
end