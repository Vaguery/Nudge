# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))


describe "IntRandom" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = IntRandom.new(@context)
  end
  
  describe "arguments" do
    it "should take no args" do
      IntRandom.should_receive(:get).exactly(0).times
      @inst.execute
    end
    
    it "should refer to #min_int and #max_int" do
      @context.should_receive(:instance_variable_get).with(:@min_int).exactly(1).times.and_return(1.0)
      @context.should_receive(:instance_variable_get).with(:@max_int).exactly(1).times.and_return(1.0)
      @inst.execute
    end
  end
  
  describe "#process" do
    it "should generate a random number" do
      Kernel.should_receive(:rand).exactly(1).times.and_return(0.5)
      @inst.execute
    end
    
    it "should sample from the range, inclusive, with equal probability" do
      @context.instance_variable_set(:@min_int, -2)
      @context.instance_variable_set(:@max_int, -2)
      Kernel.should_receive(:rand).and_return(0.0, 0.32, 0.34, 0.65, 0.67, 0.99999)
      6.times {@inst.execute}
      @context.stacks[:int].should ==  ["-2", "-2", "-2", "-2", "-2", "-2"] 
      
      @context.stacks[:int].flush
      @context.instance_variable_set(:@min_int, 2)
      @context.instance_variable_set(:@max_int, 4)
      Kernel.should_receive(:rand).and_return(0.0, 0.32, 0.34, 0.65, 0.67, 0.99999)
      6.times {@inst.execute}
      @context.stacks[:int].should == ["2", "2", "3", "3", "4", "4"]
      
      @context.stacks[:int].flush
      @context.instance_variable_set(:@min_int, -1)
      @context.instance_variable_set(:@max_int, 1)
      Kernel.should_receive(:rand).and_return(0.0, 0.333, 0.334, 0.5, 0.665, 0.667, 0.99999)
      7.times {@inst.execute}
      @context.stacks[:int].should == ["-1", "-1", "0", "0", "0", "1", "1"]
    end
  end
  
  describe "effects" do
    it "should push the result onto the :int stack" do
      @inst.execute
      @context.stacks[:int].depth.should == 1
    end
  end
end
