# encoding: UTF-8
require 'spec_helper'

describe "CodeNthPoint" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeNthPoint.new(@context)
  end
  
  describe "arguments" do
    it "should need 1 :code and 1 :int" do
      CodeNthPoint::REQUIREMENTS.should == {code:1, int:1}
    end
  end
  
  describe "#process" do
    describe "when the :int is positive and less than the number of points in the :code" do
      it "should return that point of the :code" do
        @context.stacks[:code] << "block {ref a ref b block {ref c}}"
        @context.stacks[:int] << "3"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref c}")
      end
      
      it "should return the root, if specified" do
        @context.stacks[:code] << "block {ref a ref b block {ref c}}"
        @context.stacks[:int] << "0"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref a ref b block {ref c}}")
      end
    end
    
    describe "when the :int is outside the range of (0...points)" do
      it "should take the :int modulo the number of points" do
        @context.stacks[:code] << "block {ref a ref b block {ref c}}"
        @context.stacks[:int] << "-21"
        @inst.execute
        @context.stacks[:code][-1].should match_script("ref c")
      end
      
      it "should take the :int modulo the number of points" do
        @context.stacks[:code] << "block {ref a ref b block {ref c}}"
        @context.stacks[:int] << "221"
        @inst.execute
        @context.stacks[:code][-1].should match_script("ref a")
      end
    end
    
    describe "when the code can't be parsed" do
      it "should produce an :error" do
        @context.stacks[:code] << "hsja akjsdnkasjdn"
        @context.stacks[:int] << "2"
        @context.stacks[:exec] << NudgePoint.from("do code_nth_point")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
    end
  end
end
