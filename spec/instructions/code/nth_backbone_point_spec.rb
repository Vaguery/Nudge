# encoding: UTF-8
require 'spec_helper'

describe "CodeNthBackbonePoint" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeNthBackbonePoint.new(@context)
  end
  
  describe "arguments" do
    it "should need 1 :code and 1 :int" do
      CodeNthBackbonePoint::REQUIREMENTS.should == {code:1, int:1}
    end
  end
  
  describe "#process" do
    describe "the :code is a block" do
      before(:each) do
        @context.stacks[:code] << "block {ref a ref b block {ref c}}"
      end
      
      it "should extract a point modulo the backbone_length if the :int is negative" do
        @context.stacks[:int] << "-2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("ref b")
      end
      
      describe "there are one or more points in the backbone" do
        it "should return the first point if the :int is 0" do
          @context.stacks[:int] << "0"
          @inst.execute
          @context.stacks[:code][-1].should match_script("ref a")
        end

        it "the :int is positive and less than the backbone length of the :code" do
          @context.stacks[:int] << "2"
          @inst.execute
          @context.stacks[:code][-1].should match_script("block {ref c}")
        end     
        
        it "should take the :int modulo the backbone length" do
          @context.stacks[:int] << "7"
          @inst.execute
          @context.stacks[:code][-1].should match_script("ref b")
        end   
      end
      
      describe "empty block" do
        it "should create an :error" do
          @context.stacks[:code] << "block {}"
          @context.stacks[:int] << "2"
          @context.stacks[:exec] << NudgePoint.from("do code_nth_backbone_point")
          @context.run
          @context.stacks[:error][-1].should include("InvalidIndex")
        end     
      end
    end
    
    describe "the :code is an atom" do
      before(:each) do
        @context.stacks[:code] << "ref g"
      end
      
      it "should return the item" do
        @context.stacks[:int] << "2"
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
      @context.stacks[:code] << "ref a"
      @context.stacks[:int] << "1"
      @inst.execute
      @context.stacks[:code].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "foo bar"
      @context.stacks[:int] << "1"
      @context.stacks[:exec] << NudgePoint.from("do code_nth_cdr")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
