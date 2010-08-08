# encoding: UTF-8
require 'spec_helper'

describe "CodeFlatten" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeFlatten.new(@context)
  end
  
  describe "arguments" do
    it "should need 1 :code and 1 :int" do
      CodeFlatten::REQUIREMENTS.should == {code:1, int:1}
    end
  end
  
  describe "#process" do
    describe "the :code is a block" do
      before(:each) do
        @start_tree = "block {block {} block {block {} block {block {}}}}"
        @context.stacks[:code] << @start_tree
      end   
      
      it "with a negative index should not change it" do
        @context.stacks[:int] << "-2"
        @inst.execute
        @context.stacks[:code][-1].should match_script(@start_tree)
      end
      
      it "with a zero index should not change it" do
        @context.stacks[:int] << "0"
        @inst.execute
        @context.stacks[:code][-1].should match_script(@start_tree)
      end   
      
      it "with a huge index should totally flatten it" do
        @context.stacks[:int] << "100"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {  }")
      end   
      
      it "with index=1 it should flatten at level 1 only" do
        @context.stacks[:int] << "1"
        @inst.execute
        @context.stacks[:code][-1].should_not match_script(@start_tree)
        @context.stacks[:code][-1].should match_script("block {block {} block {block {}}}")
      end
      
      it "with a middling index it should flatten everything smaller than that level" do
        @context.stacks[:int] << "2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {block {}}")
      end   
    end
    
    describe "the :code is an atom" do
      before(:each) do
        @context.stacks[:code] << "ref g"
      end
      
      it "should never change it" do
        @context.stacks[:int] << "2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("ref g")
        
        @context.stacks[:int] << "0"
        @inst.execute
        @context.stacks[:code][-1].should match_script("ref g")
        
        @context.stacks[:int] << "-2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("ref g")
      end
    end
    
    describe "the code is crap" do
      before(:each) do
        @context.stacks[:code] << "bippity boppity boo"
      end
      
      it "generates an error" do
        @context.stacks[:int] << "2"
        @context.stacks[:exec] << NudgePoint.from("do code_nth_cdr")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
    end
  end
  
  describe "output" do
    it "should push a :code item when it works" do
      @context.stacks[:code] << "block {block {ref a} ref b}"
      @context.stacks[:int] << "1"
      @inst.execute
      @context.stacks[:code].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "foo bar"
      @context.stacks[:int] << "1"
      @context.stacks[:exec] << NudgePoint.from("do code_flatten")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
