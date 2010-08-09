# encoding: UTF-8
require 'spec_helper'

describe "CodeContainer" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeContainer.new(@context)
  end
  
  describe "arguments" do
    it "should need 2 :code items" do
      CodeContainer::REQUIREMENTS.should == {code:2}
    end
  end
  
  describe "#process" do
    describe "arg1 is an atom" do
      it "should return an error" do
        @context.stacks[:code] << "ref g"
        @context.stacks[:code] << "ref h"
        @context.stacks[:exec] << NudgePoint.from("do code_container")
        @context.run
        @context.stacks[:error][-1].should include("InvalidIndex")
      end
    end
    
    describe "arg1 is a block" do
      describe "if arg2 isn't found" do
        it "should return an empty block" do
          @context.stacks[:code] << "block {ref a ref g}"
          @context.stacks[:code] << "ref h"
          @inst.execute
          @context.stacks[:code][-1].should match_script("block {}")
        end
      end
      
      describe "if arg2 is found at the root" do
        it "should return an empty block" do
          @context.stacks[:code] << "block {ref a ref g}"
          @context.stacks[:code] << "block {ref a ref g}"
          @inst.execute
          @context.stacks[:code][-1].should match_script("block {}")
        end
      end
      
      describe "if arg2 is found inside the root block" do
        it "should return the containing block" do
          @context.stacks[:code] << "block { ref a ref g }"
          @context.stacks[:code] << "ref g"
          @inst.execute
          @context.stacks[:code][-1].should match_script("block {ref a ref g}")
        end
      end
    end
    
    
    describe "the code is crap" do
      it "should generate an :error if arg1 is broken" do
        @context.stacks[:code] << "ksfkjbskdf"
        @context.stacks[:code] << "ref g"
        @context.stacks[:exec] << NudgePoint.from("do code_container")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
    end
  end
  
  describe "output" do
    it "should push one :code item when it works" do
      @context.stacks[:code] << "block {ref b}"
      @context.stacks[:code] << "ref b"
      @inst.execute
      @context.stacks[:code].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "foo bar"
      @context.stacks[:code] << "ref b"
      @context.stacks[:exec] << NudgePoint.from("do code_container")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
