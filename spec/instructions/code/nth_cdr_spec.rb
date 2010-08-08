# encoding: UTF-8
require 'spec_helper'

describe "CodeNthCdr" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeNthCdr.new(@context)
  end
  
  describe "arguments" do
    it "should need 1 :code and 1 :int" do
      CodeNthCdr::REQUIREMENTS.should == {code:1, int:1}
    end
  end
  
  describe "#process" do
    describe "the :code is a block" do
      before(:each) do
        @context.stacks[:code] << "block {ref a ref b block {ref c}}"
      end
      
      it "the :int is negative" do
        @context.stacks[:int] << "-2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref a ref b block {ref c}}")
      end
      
      it "the :int is 0" do
        @context.stacks[:int] << "0"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref a ref b block {ref c}}")
      end
      
      it "the :int is positive less than the backbone length of the :code" do
        @context.stacks[:int] << "1"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref b block {ref c}}")
      end
      
      it "the :int is positive == the backbone length of the :code" do
        @context.stacks[:int] << "3"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {}")
      end
      
      it "the :int is positive > the backbone length of the :code" do
        @context.stacks[:int] << "612"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {}")
      end
      
    end
    
    describe "the :code is an atom" do
      before(:each) do
        @context.stacks[:code] << "ref g"
      end
      
      it "the :int is negative" do
        @context.stacks[:int] << "-2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block { ref g }")
      end
      
      it "the :int is 0" do
        @context.stacks[:int] << "0"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block { ref g }")
      end
      
      it "the :int is positive" do
        @context.stacks[:int] << "2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block { }")
      end
    end
    
    describe "the code is crap" do
      before(:each) do
        @context.stacks[:code] << "bippity boppity boo"
      end
      
      it "generates an error" do
        @context.stacks[:int] << "2"
        @inst.execute
        @context.stacks[:error][-1].should == "foo"
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
      @inst.execute
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
