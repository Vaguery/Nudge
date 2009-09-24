require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "codeblock objects" do
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
    
    myB = parser.parse("block {\ninstr x\ninstr y}").to_points
    myB.tidy.should == "block {\n  instr x\n  instr y}"
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
      @ii.reset("block {\nliteral int,1\nliteral int,2\nliteral int,3\nliteral int,4}")
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
      @ii.reset("block {\nblock {\n block {\nliteral int,1}\nliteral bool,false}}")
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
    it "should return the number of lines in the listing" do
      l1 = ["block {}", "instr thing,value", "channel x1"]
      l1.each do |ll|
        CodeBlock.new(ll).points.should == 1
      end
      
      l2plus = ["block {\n  block {\n    block{}}}", "block {\n  instr thing,value\n  channel x1}"]
      l2plus.each do |ll|
        CodeBlock.new(ll).points.should == 3
      end
    end
  end
end