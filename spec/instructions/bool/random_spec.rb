# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))


describe "BoolRandom" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = BoolRandom.new(@context)
  end
  
  describe "arguments" do
    it "should take no args" do
      BoolRandom.should_receive(:get).exactly(0).times
      @inst.execute
    end
  end
  
  describe "#process" do
    it "should generate a random number" do
      Kernel.should_receive(:rand).exactly(1).times.and_return(0.5)
      @inst.execute
    end
    
    it "should generate heads and tails with equal chance" do
      Kernel.should_receive(:rand).and_return(0.4999, 0.5001)
      2.times {@inst.execute}
      @context.stacks[:bool].should == ["false", "true"]
    end
  end
  
  describe "effects" do
    it "should push the result onto the :bool stack" do
      @inst.execute
      @context.stacks[:bool].depth.should == 1
    end
  end
end
