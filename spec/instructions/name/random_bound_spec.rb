# encoding: UTF-8
require 'spec_helper'


describe "NameRandomBound" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = NameRandomBound.new(@context)
  end
  
  describe "arguments" do
    it "should need no args" do
      NameRandomBound::REQUIREMENTS.should == {}
    end
  end
  
  describe "#process" do
    it "should sample the interpreter's variable_bindings" do
      @context.bind(x:Value.new(:int, 100))
      @inst.execute
      @context.stacks[:name].should == ["x"]
    end
    
    it "should not bother when no bindings are present" do
      @inst.execute
      @context.stacks[:name].should == []
      @context.stacks[:error].should == []
    end
    
    it "should sample at random" do
      k = ["a", "b"]
      @context.variable_bindings.should_receive(:keys).and_return(k)
      k.should_receive(:sample)
      @inst.execute
    end
  end
  
  describe "effects" do
    it "should push the result onto the :name stack" do
      @context.bind(x:Value.new(:int, 100))
      @inst.execute
      @context.stacks[:name].length.should == 1
    end
  end
end
