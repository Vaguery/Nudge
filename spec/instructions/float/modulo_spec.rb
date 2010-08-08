# encoding: UTF-8
require 'spec_helper'


describe "FloatModulo" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = FloatModulo.new(@context)
  end
  
  describe "arguments" do
    it "should take two :float args" do
      FloatModulo::REQUIREMENTS.should == {float:2}
    end
  end
  
  describe "#process" do
    it "should return one :float as determined w/ Knuth's (and Ruby's) mod method" do
      @context.stacks[:float] << "23.5" << "21.0"
      @inst.execute
      @context.stacks[:float].should == ["2.5"]
    end
    
    it "should produce an :error if the result is Infinity" do
      @context.stacks[:float] << "5.9e+265" << "1.0e-89"
      @context.stacks[:exec] << NudgePoint.from("do float_modulo")
      @context.run
      @context.stacks[:float].should == []
      @context.stacks[:error][-1].should include("NaN")
    end
    
    it "should produce an :error if the result is -Infinity" do
      @context.stacks[:float] << "-5.9e+265" << "1.0e-89"
      @context.stacks[:exec] << NudgePoint.from("do float_modulo")
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
