# encoding: UTF-8
require 'spec_helper'

describe "CodeContainsQ" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeContainsQ.new(@context)
  end
  
  describe "arguments" do
    it "should need 2 :code" do
      CodeContainsQ::REQUIREMENTS.should == {code:2}
    end
  end
  
  describe "#process" do
    describe "arg1 is not a block" do
      it "should return true if arg2 has the same script" do
        @context.stacks[:code] << "ref t"
        @context.stacks[:code] << "ref t"
        @inst.execute
        @context.stacks[:bool][-1].should == "true"
      end
      
      it "should return true if arg2 is different" do
        @context.stacks[:code] << "ref t"
        @context.stacks[:code] << "ref q"
        @inst.execute
        @context.stacks[:bool][-1].should == "false"
      end
    end
    
    describe "arg1 is a block" do
      it "should return true if arg2 is present in the root" do
        @context.stacks[:code] << "block {ref g}"
        @context.stacks[:code] << "ref g"
        @inst.execute
        @context.stacks[:bool][-1].should == "true"
      end
      
      it "should return false if arg2 isn't there" do
        @context.stacks[:code] << "block {ref x}"
        @context.stacks[:code] << "ref g"
        @inst.execute
        @context.stacks[:bool][-1].should == "false"
      end
      
      it "should return true if arg2 is way down inside there" do
        @context.stacks[:code] << "block { block { ref x block {ref g}}}"
        @context.stacks[:code] << "ref g"
        @inst.execute
        @context.stacks[:bool][-1].should == "true"
      end
      
    end
  end
  
  describe "output" do
    it "should push a :bool item when it works" do
      @context.stacks[:code] << "block { block { ref x block {ref g}}}"
      @context.stacks[:code] << "ref g"
      @inst.execute
      @context.stacks[:bool].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "block { block { ref x block {ref g}}}"
      @context.stacks[:code] << "jkasdkaksd"
      @context.stacks[:exec] << NudgePoint.from("do code_contains?")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
