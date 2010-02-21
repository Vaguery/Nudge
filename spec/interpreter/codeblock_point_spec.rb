# coding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge


describe "#initialize" do
  it "should accept an Array of ProgramPoint objects, defaulting to none" do
    lambda{CodeblockPoint.new()}.should_not raise_error
    lambda{CodeblockPoint.new("block {}")}.should raise_error(ArgumentError)
    lambda{CodeblockPoint.new([ReferencePoint.new("x")])}.should_not raise_error
    CodeblockPoint.new([ReferencePoint.new("x")]).contents[0].should be_a_kind_of(ReferencePoint)
  end
end

describe "#go" do
  describe "should split at the root #contents level and push IN REVERSE ORDER back onto :exec" do
    before(:each) do
      @ii=Interpreter.new()
      @ii.clear_stacks
    end
    
    it " : if it is an empty Codeblock" do
      @ii.reset("block {}")
      @ii.step
      @ii.stacks[:exec].depth.should == 0
    end
    
    it " : if it is a long, flat Codeblock" do
      @ii.reset("block {\nref a\nref b\nref c\nref d}")
      @ii.stacks[:exec].depth.should == 1
      @ii.step
      @ii.stacks[:exec].depth.should == 4
      @ii.stacks[:exec].pop.name.should == "a"
      @ii.stacks[:exec].pop.name.should == "b"
      @ii.stacks[:exec].pop.name.should == "c"
      @ii.stacks[:exec].pop.name.should == "d"
      @ii.stacks[:exec].pop.should == nil
    end
    
    it " : if it is a deeply nested program" do
      @ii.reset("block {\nblock {\n block {\nvalue «int»}\nvalue «bool»}}")
      @ii.stacks[:exec].depth.should == 1
      @ii.step
      @ii.stacks[:exec].depth.should == 1
      @ii.step
      @ii.stacks[:exec].depth.should == 2
      @ii.step
      @ii.stacks[:exec].depth.should == 2
      item = @ii.stacks[:exec].pop
      item.should be_a_kind_of(ValuePoint)
      item.type.should == :int
      item = @ii.stacks[:exec].pop
      item.should be_a_kind_of(ValuePoint)
      item.type.should == :bool
    end
  end
end


describe "codeblock methods" do
  describe "#points" do
    it "should return the number of lines in the block" do
      myP = NudgeProgram.new("block {}")
      myP.points.should == 1
      
      myP = NudgeProgram.new("block { block { block {}}}")
      myP.points.should == 3
      
      myP = NudgeProgram.new("block { block {} block {}}")
      myP.points.should == 3
      
      myP = NudgeProgram.new("block { do int_add}")
      myP.points.should == 2
      
      myP = NudgeProgram.new("block { do int_add ref x1\nref x2}")
      myP.points.should == 4
      
    end
  end
end