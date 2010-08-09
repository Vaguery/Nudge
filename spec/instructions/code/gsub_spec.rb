# encoding: UTF-8
require 'spec_helper'

describe "CodeGsub" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeGsub.new(@context)
  end
  
  describe "arguments" do
    it "should need 3 :code items" do
      CodeGsub::REQUIREMENTS.should == {code:3}
    end
  end
  
  describe "#process" do
    
    describe "when arg2 does not appear in arg1" do
      it "should return arg1 unchanged" do
        @context.stacks[:code] << "block {do int_add}"
        @context.stacks[:code] << "ref a"
        @context.stacks[:code] << "ref b"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {do int_add}")
      end
    end
    
    describe "when arg2 appears in arg1" do
      it "should replace every occurrence of arg2 in arg1" do
        @context.stacks[:code] << "block {ref a block {ref a}}"
        @context.stacks[:code] << "ref a"
        @context.stacks[:code] << "ref b"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref b block {ref b}}")
      end
      
      it "should work with value targets" do
        @context.stacks[:code] << "block {block {value «int»} block {ref a value «int»}}\n«int»12\n«int»33"
        @context.stacks[:code] << "value «int»\n«int»33"
        @context.stacks[:code] << "ref REPLACED"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {block {value «int»} block {ref a ref REPLACED}}\n«int»12")
      end
    end
    
    describe "the code is crap" do
      it "should generate an :error if arg1 is broken" do
        @context.stacks[:code] << "ksfkjbskdf"
        @context.stacks[:code] << "ref a"
        @context.stacks[:code] << "ref b"
        @context.stacks[:exec] << NudgePoint.from("do code_gsub")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
      
      it "should generate an :error if arg2 is broken" do
        @context.stacks[:code] << "ref a"
        @context.stacks[:code] << "ksfkjbskdf"
        @context.stacks[:code] << "ref b"
        @context.stacks[:exec] << NudgePoint.from("do code_gsub")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
      
      it "should generate an :error if arg3 is broken" do
        @context.stacks[:code] << "ref a"
        @context.stacks[:code] << "ref a"
        @context.stacks[:code] << "klasdad"
        @context.stacks[:exec] << NudgePoint.from("do code_gsub")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
      
    end
  end
  
  describe "output" do
    it "should push one :code item when it works" do
      @context.stacks[:code] << "block {ref a}"
      @context.stacks[:code] << "ref a"
      @context.stacks[:code] << "ref z"
      @inst.execute
      @context.stacks[:code].length.should == 1
    end 
    
    #just checking one
    it "should push an :error when it fails" do 
      @context.stacks[:code] << "foo bar"
      @context.stacks[:code] << "ref a"
      @context.stacks[:code] << "ref g"
      @context.stacks[:exec] << NudgePoint.from("do code_gsub")
      @context.run
      @context.stacks[:error].length.should == 1
      @context.stacks[:code].length.should == 0
    end
  end
end
