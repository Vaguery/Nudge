# encoding: UTF-8
require 'spec_helper'

describe "CodeTreeDuplicate" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeTreeDuplicate.new(@context)
  end
  
  describe "arguments" do
    it "should need 1 :code" do
      CodeTreeDuplicate::REQUIREMENTS.should == {code:1}
    end
  end
  
  describe "#process" do
    describe "the :code item is a block" do
      it "should duplicate the first backbone point" do
        @context.stacks[:code] << "block {ref a ref b}"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref a ref a ref b}")
      end
      
      it "should duplicate it even if it's a block" do
        @context.stacks[:code] << "block {block {} ref b}"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {block {} block {} ref b}")
      end
      
      it "should do nothing if it's an empty block" do
        @context.stacks[:code] << "block {}"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {}")
      end
    end
    
    describe "the :code is an atom" do
      it "should wrap it first in a block" do
        @context.stacks[:code] << "do int_add"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {do int_add do int_add}")
      end
    end
    
    describe "the code is crap" do
      it "should generate an :error if arg1 is broken" do
        @context.stacks[:code] << "ksfkjbskdf"
        @context.stacks[:code] << "ref y"
        @context.stacks[:exec] << NudgePoint.from("do code_position")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
    end
  end
  
  describe "output" do
    it "should push a :code item when it works" do
      @context.stacks[:code] << "block {ref b}"
      @inst.execute
      @context.stacks[:code].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "foo bar"
      @context.stacks[:exec] << NudgePoint.from("do code_tree_duplicate")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
