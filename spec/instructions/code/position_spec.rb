# encoding: UTF-8
require 'spec_helper'

describe "CodePosition" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodePosition.new(@context)
  end
  
  describe "arguments" do
    it "should need 2 :code" do
      CodePosition::REQUIREMENTS.should == {code:2}
    end
  end
  
  describe "#process" do
    describe "arg1 is a block" do
      before(:each) do
        @context.stacks[:code] << "block {ref a ref b block {ref c} ref a}"
      end
      
      it "arg2 is found in it" do
        @context.stacks[:code] << "ref b"
        @inst.execute
        @context.stacks[:int][-1].should == "2"
      end
      
      it "arg2 is identical" do
        @context.stacks[:code] << "block {ref a ref b block {ref c} ref a}"
        @inst.execute
        @context.stacks[:int][-1].should == "0"
      end
      
      it "arg2 is not found" do
        @context.stacks[:code] << "ref g"
        @context.stacks[:exec] << NudgePoint.from("do code_position")
        @context.run
        @context.stacks[:int].depth.should == 0
        @context.stacks[:error][-1].should include("NotFound")
      end
      
      it "should return the first occurrence" do
        @context.stacks[:code] << "ref a"
        @context.stacks[:exec] << NudgePoint.from("do code_position")
        @inst.execute
        @context.stacks[:int][-1].should == "1"
      end
    end
    
    describe "the :code is an atom" do
      before(:each) do
        @context.stacks[:code] << "ref g"
      end
      
      it "should return 0 if arg2 is identical" do
        @context.stacks[:code] << "ref g"
        @inst.execute
        @context.stacks[:int][-1].should == "0"
      end
      
      it "should return an :error if they are not" do
        @context.stacks[:code] << "ref y"
        @context.stacks[:exec] << NudgePoint.from("do code_position")
        @context.run
        @context.stacks[:error][-1].should include("NotFound")
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
      
      it "should generate an :error if arg2 is broken" do
        @context.stacks[:code] << "ref g"
        @context.stacks[:code] << "refiasba ds"
        @context.stacks[:exec] << NudgePoint.from("do code_position")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
    end
  end
  
  describe "output" do
    it "should push an :int item when it works" do
      @context.stacks[:code] << "block {ref b}"
      @context.stacks[:code] << "ref b"
      @inst.execute
      @context.stacks[:int].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "foo bar"
      @context.stacks[:code] << "hahjsd"
      @context.stacks[:exec] << NudgePoint.from("do code_position")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
