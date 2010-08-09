# encoding: UTF-8
require 'spec_helper'

describe "CodeDiscrepancy" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = CodeDiscrepancy.new(@context)
  end
  
  describe "arguments" do
    it "should need 2 :code" do
      CodeDiscrepancy::REQUIREMENTS.should == {code:2}
    end
  end
  
  describe "#process" do
    it "should count the number of copies of each point in each arg" do
      @inst.should_receive(:point_hash).exactly(2).times.and_return({'ref fake'=>2})
      @context.stacks[:code] << "block {ref a block {ref c} block {ref c ref a}}"
      @context.stacks[:code] << "block {ref a ref b ref c ref a}"
      @inst.execute
    end
    
    context "the arguments are identical" do
      it "should return 0" do
        @context.stacks[:code] << "block {ref a block {ref c} block {ref c ref a}}"
        @context.stacks[:code] << "block {ref a block {ref c} block {ref c ref a}}"
        @inst.execute
        @context.stacks[:int][-1].should == "0"
      end
    end
    
    context "the arguments are totally different" do
      it "should return the total number of points in both" do
        @context.stacks[:code] << "block {ref a block {ref b} block {ref c ref d}}" # 7 points
        @context.stacks[:code] << "block {ref h block {ref f ref e}}" # 5 points
        @inst.execute
        @context.stacks[:int][-1].should == "12"
      end
    end
    
    context "the arguments contain the same points in different order" do
      it "should count both roots as different from one another" do
        @context.stacks[:code] << "block {ref a block {ref a ref a}}"
        @context.stacks[:code] << "block {block {ref a ref a} ref a}"
        @inst.execute
        @context.stacks[:int][-1].should == "2"
      end
    end
    
    describe "the code is crap" do
      it "generates an error when arg1 is junk" do
        @context.stacks[:code] << "ref a"
        @context.stacks[:code] << "jdskjnsdf kjnskfd"
        @context.stacks[:exec] << NudgePoint.from("do code_discrepancy")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
      
      it "generates an error when arg2 is junk" do
        @context.stacks[:code] << "refasudiadissa a"
        @context.stacks[:code] << "ref a"
        @context.stacks[:int] << "2"
        @context.stacks[:exec] << NudgePoint.from("do code_discrepancy")
        @context.run
        @context.stacks[:error][-1].should include("InvalidScript")
      end
      
    end
  end
  
  describe "output" do
    it "should push an :int item when it works" do
      @context.stacks[:code] << "ref a"
      @context.stacks[:code] << "do int_add"
      @inst.execute
      @context.stacks[:int].length.should == 1
    end 
    
    it "should push an :error when it fails" do
      @context.stacks[:code] << "ref a"
      @context.stacks[:code] << "jdskjnsdf kjnskfd"
      @context.stacks[:exec] << NudgePoint.from("do code_discrepancy")
      @context.run
      @context.stacks[:code].length.should == 0
      @context.stacks[:error].length.should == 1
    end
  end
end
