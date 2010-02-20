# coding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "CodeblockPoint objects" do
  describe "should only accept #new from a NudgeProgramParser"
  
  it "should be a kind of program point" do
    myB = CodeblockPoint.new()
    myB.should be_a_kind_of(ProgramPoint)
  end
  
  it "should take an array of ProgramPoint objects as an input, default to an empty Array" do
    sCode = CodeblockPoint.new()
    sCode.contents.should == []
    tCode = CodeblockPoint.new([InstructionPoint.new("image_rotate")])
    tCode.contents[0].should be_a_kind_of(InstructionPoint)
    tCode.contents[0].name.should == "image_rotate"
  end
  
  it "should expose its #contents" do
    raise "FIX THIS"
    parser = NudgeProgramParser.new()
    cbs = ["block {\n  literal int(3)}",
      "block { do int_add \ndo int_subtract\n do int_divide}",
      "block { block{}}", "block{ block{ do int_add block{ block{} block{}}} }"]
    
    cbs.each do |myCode|
      handMade = CodeblockPoint.new(myCode)
      generated = parser.parse(myCode).to_point
      handMade.contents.length.should == generated.contents.length
      handMade.contents[0].tidy.should == generated.contents[0].tidy
      handMade.listing.should == generated.listing
    end
  end
  
  
  it "should return an indented nested text version for #tidy" do
    parser = NudgeLanguageParser.new()
    myB = parser.parse("block {}").to_points
    myB.tidy.should == "block {}"
    
    myB = parser.parse("block {\n\n}").to_points
    myB.tidy.should == "block {}"
    
    myB = parser.parse("block {\nblock{}\n}").to_points
    myB.tidy.should == "block {\n  block {}}"
    
    myB = parser.parse("block {\nblock{\nblock{}}\n}").to_points
    myB.tidy.should == "block {\n  block {\n    block {}}}"
    
    myB = parser.parse("block {\nblock{}\nblock{}}").to_points
    myB.tidy.should == "block {\n  block {}\n  block {}}"
    
    myB = parser.parse("block {\ndo x\ndo y}").to_points
    myB.tidy.should == "block {\n  do x\n  do y}"
  end
  
  it "--no really, even for VERY complicated trees" do
    parser = NudgeLanguageParser.new()
    myComplicated = fixture(:untidy1)
    myExpected = fixture(:untidy1fixed)
    myB = parser.parse(myComplicated).to_points
    myB.tidy.should == myExpected.chomp
    
    myDeep = "block {"* 88 + "}"*88
    myB = parser.parse(myDeep).to_points
    myB.tidy.split(/\n/).length.should == 88
  end
end

describe "#go" do
  describe "should split at the root #contents level and push IN REVERSE ORDER back onto :exec" do
    before(:each) do
      @ii = Interpreter.new()
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