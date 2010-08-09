# encoding: UTF-8
require 'spec_helper'

describe "CodeDeleteNthPoint" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeDeleteNthPoint.new(@context)
  end
  
  describe "arguments" do
    it "should need 1 :code and 1 :int" do
      CodeDeleteNthPoint::REQUIREMENTS.should == {code:1, int:1}
    end
  end
  
  describe "#process" do
    describe "when the code has 1 point" do
      it "should replace delete the item and be done" do
        @context.stacks[:code] << "ref d"
        @context.stacks[:int] << "0"
        @inst.execute
        @context.stacks[:code].length.should == 0
      end
    end
    
    describe "when arg1 has more than one point" do
      before(:each) do
        @context.stacks[:code] << "block {ref a block {ref b} ref c}"
      end
      
      it "should remove the point as indicated" do
        @context.stacks[:int] << "2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref a ref c}")
      end
      
      it "should take the pointer modulo the number of points in the code" do
        @context.stacks[:int] << "-2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref a block {} ref c}")
      end
      
      it "should delete the code if the pointer refers to the root" do
        @context.stacks[:int] << "-5"
        @inst.execute
        @context.stacks[:code].length.should == 0
      end
    end
    
    describe "the code is crap" do
      
      it "generates an error when the code is junk" do
        @context.stacks[:code] << "jdskjnsdf kjnskfd"
        @context.stacks[:int] << "2"
        @context.stacks[:exec] << NudgePoint.from("do code_delete_nth_point")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
    end
  end
  
  describe "output" do
    it "should push a :code item when it deletes an internal point" do
      @context.stacks[:code] << "block {do int_add}"
      @context.stacks[:int] << "1"
      @inst.execute
      @context.stacks[:code].length.should == 1
    end 
    
    it "should push nothing when it deletes a root point" do
      @context.stacks[:code] << "block {do int_add}"
      @context.stacks[:int] << "0"
      @inst.execute
      @context.stacks[:code].length.should == 0
    end 
    
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "jdskjnsdf kjnskfd"
      @context.stacks[:int] << "2"
      @context.stacks[:exec] << NudgePoint.from("do code_delete_nth_point")
      @context.run
      @context.stacks[:code].length.should == 0
      @context.stacks[:error].length.should == 1
    end
  end
end
