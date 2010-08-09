# encoding: UTF-8
require 'spec_helper'

describe "CodeTreeMaxdepth" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeTreeMaxdepth.new(@context)
  end
  
  describe "arguments" do
    it "should need 1 :code" do
      CodeTreeMaxdepth::REQUIREMENTS.should == {code:1}
    end
  end
  
  describe "#process" do
    describe "the :code is an atom" do
      it "should return 1" do
        @context.stacks[:code] << "ref t"
        @inst.execute
        @context.stacks[:int][-1].should == "1"
      end
    end
    
    describe "the :code item is a block" do
      it "should return 1 for an empty block" do
        @context.stacks[:code] << "block {}"
        @inst.execute
        @context.stacks[:int][-1].should == "1"
      end
      
      it "should return 2 for a flat block" do
        @context.stacks[:code] << "block {ref t}"
        @inst.execute
        @context.stacks[:int][-1].should == "2"
      end
      
      it "should return the deepest depth encountered in the tree traversal" do
        @context.stacks[:code] << "block {ref a block {ref a block {}}}"
        @inst.execute
        @context.stacks[:int][-1].should == "3"
      end
      
      it "shouldn't be confused by zigzagging" do
        @context.stacks[:code] << "block {ref a block {block {block {} ref a block {ref DEEP}} ref a }}"
        @inst.execute
        @context.stacks[:int][-1].should == "5"
      end
    end
    
    
    describe "the code is crap" do
      it "should generate an :error if arg1 is broken" do
        @context.stacks[:code] << "ksfkjbskdf"
        @context.stacks[:exec] << NudgePoint.from("do code_tree_maxdepth")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
    end
  end
  
  describe "output" do
    it "should push an :int item when it works" do
      @context.stacks[:code] << "block {ref b}"
      @inst.execute
      @context.stacks[:int].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "foo bar"
      @context.stacks[:exec] << NudgePoint.from("do code_tree_maxdepth")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
