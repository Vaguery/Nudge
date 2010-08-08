# encoding: UTF-8
require File.expand_path("../../../nudge", File.dirname(__FILE__))


describe "FloatDivide" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = FloatDivide.new(@context)
  end
  
  describe "arguments" do
    it "should take two :float args" do
      FloatDivide::REQUIREMENTS.should == {float:2}
    end
  end
  
  describe "#process" do
    it "should return one :float as determined w/ Knuth's (and Ruby's) divmod method" do
      @context.stacks[:float] << "24.0" << "12.0"
      @inst.execute
      @context.stacks[:float].should == ["2.0"]
    end
    
    it "should produce an :error if the result is Infinity" do
      @context.stacks[:float] << "5.9e+265" << "1.0e-89"
      @context.stacks[:exec] << NudgePoint.from("do float_divide")
      @context.run
      @context.stacks[:float].should == []
      @context.stacks[:error][-1].should include("NaN")
    end
    
    it "should produce an :error if the result is -Infinity" do
      @context.stacks[:float] << "-5.9e+265" << "1.0e-89"
      @context.stacks[:exec] << NudgePoint.from("do float_divide")
      @context.run
      @context.stacks[:float].should == []
      @context.stacks[:error][-1].should include("NaN")
    end    
  end
  
  describe "effects" do
    it "should push the result onto the :float stack" do
      @context.stacks[:float] << "12" << "5"
      @inst.execute
      @context.stacks[:float].length.should == 1
    end
  end
end
