require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "codeblock objects" do
  describe "should only accept #new from a NudgeLanguageParser"
  
  it "should be a kind of program point" do
    myB = CodeBlock.new()
    myB.should be_a_kind_of(ProgramPoint)
  end
  
  it "should take a listing as a param, default to 'block {}'" do
    sCode = CodeBlock.new()
    sCode.listing.should == "block {}"
    tCode = CodeBlock.new("block {\n  literal int, 3}")
    tCode.listing.should == "block {\n  literal int, 3}"
  end
  
  it "should expose its #contents" do
    parser = NudgeLanguageParser.new()
    cbs = ["block {\n  literal int(3)}",
      "block { do int_add \ndo int_subtract\n do int_divide}",
      "block { block{}}", "block{ block{ do int_add block{ block{} block{}}} }"]
    
    cbs.each do |myCode|
      handMade = CodeBlock.new(myCode)
      generated = parser.parse(myCode).to_points
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
      Stack.cleanup
    end
    
    it " : if it is an empty Codeblock" do
      @ii.reset("block {}")
      @ii.step
      Stack.stacks[:exec].depth.should == 0
    end
    
    it " : if it is a long, flat Codeblock" do
      @ii.reset("block {\nliteral int(1)\nliteral int(2)\nliteral int(3)\nliteral int(4)}")
      Stack.stacks[:exec].depth.should == 1
      @ii.step
      Stack.stacks[:exec].depth.should == 4
      Stack.stacks[:exec].pop.value.should == 1
      Stack.stacks[:exec].pop.value.should == 2
      Stack.stacks[:exec].pop.value.should == 3
      Stack.stacks[:exec].pop.value.should == 4
      Stack.stacks[:exec].pop.should == nil
    end
    
    it " : if it is a deeply nested Codeblock" do
      @ii.reset("block {\nblock {\n block {\nliteral int (1)}\nliteral bool (false)}}")
      Stack.stacks[:exec].depth.should == 1
      @ii.step
      Stack.stacks[:exec].depth.should == 1
      @ii.step
      Stack.stacks[:exec].depth.should == 2
      @ii.step
      Stack.stacks[:exec].depth.should == 2
      item = Stack.stacks[:exec].pop
      item.should be_a_kind_of(LiteralPoint)
      item.value.should == 1
      item = Stack.stacks[:exec].pop
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