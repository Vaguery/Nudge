# encoding: UTF-8
require 'spec_helper'

describe "CodeInBackboneQ" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeInBackboneQ.new(@context)
  end
  
  describe "arguments" do
    it "should need 1 :code" do
      CodeInBackboneQ::REQUIREMENTS.should == {code:2}
    end
  end
  
  describe "#process" do
    describe "the first arg is a block" do
      it "should return true if the second item is in its backbone" do
        @context.stacks[:code] << "block {ref a ref b}"
        @context.stacks[:code] << "ref b"
        @inst.execute
        @context.stacks[:bool][-1].should == "true"
      end
      
      it "should return false if the second item is not in the backbone" do
        @context.stacks[:code] << "block {ref a}"
        @context.stacks[:code] << "ref b"
        @inst.execute
        @context.stacks[:bool][-1].should == "false"
      end
      
      it "should return false if the second item is deeper than the backbone" do
        @context.stacks[:code] << "block {ref a block {ref b}}"
        @context.stacks[:code] << "ref b"
        @inst.execute
        @context.stacks[:bool][-1].should == "false"
      end
      
      it "should return false if the second item is identical" do
        @context.stacks[:code] << "block {ref a}"
        @context.stacks[:code] << "block {ref a}"
        @inst.execute
        @context.stacks[:bool][-1].should == "false"
      end
    end
    
    describe "the first arg is not a block" do
      it "should return false" do
        @context.stacks[:code] << "ref a"
        @context.stacks[:code] << "ref b"
        @inst.execute
        @context.stacks[:bool][-1].should == "false"
      end
    end
    
    describe "bad code" do
      it "should return push an error if either arg is bad" do
        @context.stacks[:code] << "gibberish"
        @context.stacks[:code] << "ref b"
        @context.stacks[:exec] << NudgePoint.from("do code_in_backbone?")
        @context.run
        @context.stacks[:bool].length.should == 0
        @context.stacks[:error][-1].should include("InvalidScript") 
        
        @context.stacks[:error].flush
        @context.stacks[:code] << "block {ref d}"
        @context.stacks[:code] << "lsjkajnsdkasd"
        @context.stacks[:exec] << NudgePoint.from("do code_in_backbone?")
        @context.run
        @context.stacks[:bool].length.should == 0
        @context.stacks[:error][-1].should include("InvalidScript")
      end      
    end
  end
  
  describe "output" do
    it "should push a :bool if it works" do
      @context.stacks[:code] << "block {block {ref a} ref b}"
      @context.stacks[:code] << "block {ref a}"
      @inst.execute
      @context.stacks[:bool].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "block {ref d}"
      @context.stacks[:code] << "lsjkajnsdkasd"
      @context.stacks[:exec] << NudgePoint.from("do code_in_backbone?")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
