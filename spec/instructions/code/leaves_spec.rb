# encoding: UTF-8
require 'spec_helper'

describe "CodeLeaves" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeLeaves.new(@context)
  end
  
  describe "arguments" do
    it "should need 1 :code" do
      CodeLeaves::REQUIREMENTS.should == {code:1}
    end
  end
  
  describe "#process" do
    describe "the :code is a block" do
      describe "a simple block" do
        it "should push the contents onto :code" do
          @context.stacks[:code] << "block {ref g}"
          @inst.execute
          @context.stacks[:code][-1].should match_script("ref g")
        end
      end
      
      describe "a flat block" do
        it "should push the elements onto the :code stack in that order" do
          @context.stacks[:code] << "block {ref a ref b ref c}"
          @inst.execute
          @context.stacks[:code][-1].should match_script("ref c")
          @context.stacks[:code][-2].should match_script("ref b")
          @context.stacks[:code][-3].should match_script("ref a")
        end
      end
      
      describe "a nested block" do
        it "should push the atoms onto the :code stack in depth-first order" do
          @context.stacks[:code] << "block {block {ref a block {ref b ref c}}}"
          @inst.execute
          @context.stacks[:code][-1].should match_script("ref c")
          @context.stacks[:code][-2].should match_script("ref b")
          @context.stacks[:code][-3].should match_script("ref a")
        end
        
        it "should discard empty blocks" do
          @context.stacks[:code] << "block {block {} ref a block {ref b block {} ref c}}"
          @inst.execute
          @context.stacks[:code][-1].should match_script("ref c")
          @context.stacks[:code][-2].should match_script("ref b")
          @context.stacks[:code][-3].should match_script("ref a")
        end
      end
    end
    
    describe "the :code is an atom" do
      it "should never change it" do
        @context.stacks[:code] << "ref g"
        @inst.execute
        @context.stacks[:code][-1].should match_script("ref g")
      end
    end
    
    describe "the code is crap" do
      it "generates an error" do
        @context.stacks[:code] << "jashbaf"
        @context.stacks[:exec] << NudgePoint.from("do code_leaves")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
    end
  end
  
  describe "output" do
    it "should push a :code item for every atom when it works" do
      @context.stacks[:code] << "block {block {ref a} ref b}"
      @context.stacks[:int] << "1"
      @inst.execute
      @context.stacks[:code].length.should == 2
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "foo bar"
      @context.stacks[:int] << "1"
      @context.stacks[:exec] << NudgePoint.from("do code_leaves")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
