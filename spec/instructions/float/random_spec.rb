# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))


describe "FloatRandom" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = FloatRandom.new(@context)
  end
  
  describe "arguments" do
    it "should take no args" do
      FloatRandom.should_receive(:get).exactly(0).times
      @inst.execute
    end
    
    it "should refer to #min_float and #max_float" do
      @context.should_receive(:instance_variable_get).with(:@min_float).exactly(1).times.and_return(1.0)
      @context.should_receive(:instance_variable_get).with(:@max_float).exactly(1).times.and_return(1.0)
      @inst.execute
    end
  end
  
  describe "#process" do
    it "should generate a random number" do
      Kernel.should_receive(:rand).exactly(1).times.and_return(0.5)
      @inst.execute
    end
    
    it "should sample from the specified range with uniform probability" do
      @context.instance_variable_set(:@min_float, 2.0)
      @context.instance_variable_set(:@max_float, 2.8)
      Kernel.should_receive(:rand).and_return(0.0, 0.5, 0.999)
      3.times {@inst.execute}
      @context.stacks[:float][-1].to_f.should be_close(2.8, 0.001)
      @context.stacks[:float][-2].to_f.should be_close(2.4, 0.001)
      @context.stacks[:float][-3].to_f.should be_close(2.0, 0.001)
    end
    
  end
  
  describe "effects" do
    it "should push the result onto the :float stack" do
      @inst.execute
      @context.stacks[:float].depth.should == 1
    end
  end
end
