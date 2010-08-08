# encoding: UTF-8
require 'spec_helper'

describe "CodeReplaceNthPoint" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeReplaceNthPoint.new(@context)
  end
  
  describe "arguments" do
    it "should need 2 :code and 1 :int" do
      CodeReplaceNthPoint::REQUIREMENTS.should == {code:2, int:1}
    end
  end
  
  describe "#process" do
    describe "when arg1 has 1 point" do
      before(:each) do
        @context.stacks[:code] << "block {}"
      end
      
      it "should replace arg1 entirely with arg2" do
        @context.stacks[:code] << "ref d"
        @context.stacks[:int] << "13"
        @inst.execute
        @context.stacks[:code][-1].should match_script("ref d")
      end
    end
    
    describe "when arg1 has more than one point" do
      before(:each) do
        @context.stacks[:code] << "block {ref a block {ref b} ref c}"
      end
      
      it "should replace the point of arg1 as indicated, if it's less than the number of points" do
        @context.stacks[:code] << "ref pppp"
        @context.stacks[:int] << "2"
        @inst.execute
        @context.stacks[:code][-1].should match_script("block {ref a ref pppp ref c}")
      end
    end
    
    describe "the code is crap" do
      
      it "generates an error when arg1 is junk" do
        @context.stacks[:code] << "ref a"
        @context.stacks[:code] << "jdskjnsdf kjnskfd"
        @context.stacks[:int] << "2"
        @context.stacks[:exec] << NudgePoint.from("do code_replace_nth_point")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
      
      it "generates an error when arg2 is junk" do
        @context.stacks[:code] << "refasudiadissa a"
        @context.stacks[:code] << "ref a"
        @context.stacks[:int] << "2"
        @context.stacks[:exec] << NudgePoint.from("do code_replace_nth_point")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
      
    end
  end
  
  describe "output" do
    it "should push an :int item when it works" do
      @context.stacks[:code] << "ref a"
      @context.stacks[:code] << "do int_add"
      @context.stacks[:int] << "1"
      @inst.execute
      @context.stacks[:code].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "ref a"
      @context.stacks[:code] << "jdskjnsdf kjnskfd"
      @context.stacks[:int] << "2"
      @context.stacks[:exec] << NudgePoint.from("do code_replace_nth_point")
      @context.run
      @context.stacks[:code].length.should == 0
      @context.stacks[:error].length.should == 1
    end
  end
end
