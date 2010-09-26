# encoding: UTF-8
require 'spec_helper'


describe "BoolToffoli" do
  before(:each) do
    @context = NudgeExecutable.new("")
    @inst = BoolToffoli.new(@context)
  end
  
  describe "arguments" do
    it "should take three :bool args" do
      BoolToffoli::REQUIREMENTS.should == {bool:3}
    end
  end
  
  describe "#process and #effects" do
    before(:each) do
      @combos = [[true, true, true], [true, true, false], [true, false, true], [true, false, false], [false, true, true], [false, true, false], [false, false, true], [false, false,false]]
    end
    
    
    it "should leave the first input unchanged" do
      @combos.each do |combo|
        prog = "block {value «bool» value «bool» value «bool»\n«bool» #{combo[0]}}\n«bool» #{combo[1]}}\n«bool» #{combo[2]}}"
        @context = NudgeExecutable.new(prog)
        @context.stacks[:bool] << combo[0] << combo[1] << combo[2]
        BoolToffoli.new(@context).execute
        @context.stacks[:bool][-3].should == combo[0].to_s
      end
    end
    
    it "should leave the second input unchanged" do
      @combos.each do |combo|
        prog = "block {value «bool» value «bool» value «bool»\n«bool» #{combo[0]}}\n«bool» #{combo[1]}}\n«bool» #{combo[2]}}"
        @context = NudgeExecutable.new(prog)
        @context.stacks[:bool] << combo[0] << combo[1] << combo[2]
        BoolToffoli.new(@context).execute
        @context.stacks[:bool][-2].should == combo[1].to_s
      end
    end
    
    it "should return Toffoli operator on top" do
      @combos.each do |combo|
        prog = "block {value «bool» value «bool» value «bool»\n«bool» #{combo[0]}}\n«bool» #{combo[1]}}\n«bool» #{combo[2]}}"
        @context = NudgeExecutable.new(prog)
        @context.stacks[:bool] << combo[0] << combo[1] << combo[2]
        BoolToffoli.new(@context).execute
        @context.stacks[:bool][-1].should == (combo[2] != (combo[0] && combo[1])).to_s 
      end
    end
    
  end
end
