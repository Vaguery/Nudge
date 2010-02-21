# coding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "something simple" do
  it "should description" do
    @ii = Interpreter.new
  end
end


describe "#go" do
  describe "should split at the root #contents level and push IN REVERSE ORDER back onto :exec" do
    before(:each) do
      Interpreter.new()
      @ii.clear_stacks
    end
    
    it " : if it is an empty Codeblock" do
      @ii.reset("block {}")
      @ii.step
      @ii.stacks[:exec].depth.should == 0
    end
    
    it " : if it is a long, flat Codeblock" do
      @ii.reset("block {\nliteral int(1)\nliteral int(2)\nliteral int(3)\nliteral int(4)}")
      @ii.stacks[:exec].depth.should == 1
      @ii.step
      @ii.stacks[:exec].depth.should == 4
      @ii.stacks[:exec].pop.value.should == 1
      @ii.stacks[:exec].pop.value.should == 2
      @ii.stacks[:exec].pop.value.should == 3
      @ii.stacks[:exec].pop.value.should == 4
      @ii.stacks[:exec].pop.should == nil
    end
    
    it " : if it is a deeply nested Codeblock" do
      @ii.reset("block {\nblock {\n block {\nliteral int (1)}\nliteral bool (false)}}")
      @ii.stacks[:exec].depth.should == 1
      @ii.step
      @ii.stacks[:exec].depth.should == 1
      @ii.step
      @ii.stacks[:exec].depth.should == 2
      @ii.step
      @ii.stacks[:exec].depth.should == 2
      item = @ii.stacks[:exec].pop
      item.should be_a_kind_of(LiteralPoint)
      item.value.should == 1
      item = @ii.stacks[:exec].pop
      item.should be_a_kind_of(LiteralPoint)
      item.value.should == false
    end
  end
end


describe "codeblock methods" do
  describe "#points" do
    it "should return the number of lines in the block" do
      myP = CodeBlock.new("block {}")
      myP.points.should == 1
      
      myP = CodeBlock.new("block { block { block {}}}")
      myP.points.should == 3
      
      myP = CodeBlock.new("block { block {} block {}}")
      myP.points.should == 3
      
      myP = CodeBlock.new("block { do int_add}")
      myP.points.should == 2
      
      myP = CodeBlock.new("block { do int_add ref x1\nref x2}")
      myP.points.should == 4
      
    end
  end
end