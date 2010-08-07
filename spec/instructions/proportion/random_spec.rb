# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))


describe "ProportionRandom" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = ProportionRandom.new(@context)
  end
  
  describe "arguments" do
    it "should take no args" do
      ProportionRandom::REQUIREMENTS.should == {}
    end
  end
  
  describe "#process" do
    it "should generate a random number" do
      Kernel.should_receive(:rand).exactly(1).times
      @inst.execute
    end
    
    it "should produce uniform samples from [0.0,1.0)" do
      Kernel.should_receive(:rand).and_return(0.123, 0.999)
      2.times {@inst.execute}
      @context.stacks[:proportion].should == ["0.123", "0.999"]
    end
  end
  
  describe "effects" do
    it "should push the result onto the :proportion stack" do
      @inst.execute
      @context.stacks[:proportion].length.should == 1
    end
  end
end
