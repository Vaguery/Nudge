require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Int Parser" do
  describe "IntPointParser#build method" do
    it "should accept one string parameter (of some sort) that is munged into the actual value" do
      IntPointParser.new.build("3").should == 3
      lambda{IntPointParser.new.build()}.should raise_error
    end
  end
end

describe "Any Bool" do
  describe "BoolPointParser#build method" do
    it "should accept one string parameter (of some sort) that is munged into the actual value" do
      BoolPointParser.new.build("false").should == false
      lambda{BoolPointParser.new.build()}.should raise_error
    end
  end
end

describe "Any Float" do
  describe "FloatPointParser#build method" do
    it "should accept one string parameter (of some sort) that is munged into the actual value" do
      FloatPointParser.new.build("3.331").should == 3.331
      lambda{FloatPointParser.new.build()}.should raise_error
    end
  end
end
