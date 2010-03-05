# encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

def magicCodeblockPointMaker(program_listing)
  my_kludge = NudgeProgram.new(program_listing)
  return my_kludge.linked_code
end


describe "#initialize" do
  it "should accept an Array of ProgramPoint objects, defaulting to none" do
    lambda{CodeblockPoint.new()}.should_not raise_error
    lambda{CodeblockPoint.new("block {}")}.should raise_error(ArgumentError)
    lambda{CodeblockPoint.new([ReferencePoint.new("x")])}.should_not raise_error
    CodeblockPoint.new([ReferencePoint.new("x")]).contents[0].should be_a_kind_of(ReferencePoint)
  end
end

describe "tidy" do
  it "should return the #tidy string of the codeblock, with 0 indent" do
    CodeblockPoint.new([]).tidy.should == "block {}"
    CodeblockPoint.new([CodeblockPoint.new([CodeblockPoint.new])]).tidy.should ==
      "block {\n  block {\n    block {}}}"
    CodeblockPoint.new([ReferencePoint.new("a"), ValuePoint.new("b")]).tidy.should ==
      "block {\n  ref a\n  value «b»}"
  end
end


describe "listing_parts" do
  context "when there are no footnotes" do
    it "should produce an Array with (1) self.tidy and (2) an empty string" do
      CodeblockPoint.new([]).listing_parts.should == ["block {}",""]
      CodeblockPoint.new([CodeblockPoint.new([CodeblockPoint.new])]).listing_parts.should ==
        ["block {\n  block {\n    block {}}}",""]        
      CodeblockPoint.new([ReferencePoint.new("a"), InstructionPoint.new("b")]).listing_parts.should ==
        ["block {\n  ref a\n  do b}",""]
    end
  end
  
  context "when there need to be footnotes" do
    it "should work for blocks containing nil-valued ValuePoints" do
      CodeblockPoint.new([ValuePoint.new("foo")]).listing_parts.should ==
        ["block {\n  value «foo»}",""]
      annoyinglyWordy = magicCodeblockPointMaker("block { block { block { value «foo»}}}")
      annoyinglyWordy.listing_parts.should ==
        ["block {\n  block {\n    block {\n      value «foo»}}}",""]
    end
    
    it "should work with footnotes from the root" do
      simple1 = magicCodeblockPointMaker("block { value «foo»} \n«foo» bar")
      simple1.listing_parts.should ==
        ["block {\n  value «foo»}","«foo» bar"]
      nested = magicCodeblockPointMaker("block { block { value «foo»} ref x} \n«foo» bar")
      nested.listing_parts[1].should == "«foo» bar"
    end
    
    it "should return the footnotes in depth-first order" do
      listed = magicCodeblockPointMaker("block { value «c» value «b» value «a»} \n«a» 1\n«b» 2\n«c» 3")
      listed.listing_parts[1].should == "«c» 3\n«b» 2\n«a» 1"
    end
    
    it "should work with nested «code» footnotes" do
      simple_tricky = "block { value «code»}\n«code» value «code»\n«int» 123\n«code» value «int»"
      simple_tricky = magicCodeblockPointMaker(simple_tricky)
      simple_tricky.listing_parts[1].should == "«code» value «code»\n«code» value «int»\n«int» 123"
    end
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
      myP = CodeblockPoint.new()
      myP.points.should == 1
      
      myQ = CodeblockPoint.new([CodeblockPoint.new([myP])])
      myQ.points.should == 3
      
      myQ = CodeblockPoint.new([CodeblockPoint.new, CodeblockPoint.new])
      myQ.points.should == 3
      
      myQ = CodeblockPoint.new([InstructionPoint.new("int_add")])
      myQ.points.should == 2
      
      myP = CodeblockPoint.new([InstructionPoint.new("a"),ReferencePoint.new("b"),ReferencePoint.new("c")])
      myP.points.should == 4
    end
  end
  
  
  describe "each" do
    before(:each) do
      @myQ = CodeblockPoint.new([ReferencePoint.new("a"), InstructionPoint.new("b")])
    end
    
    it "should return an Enumerator object of the right size" do
      @myQ = CodeblockPoint.new([ReferencePoint.new("a"), InstructionPoint.new("b")])
      @myQ.collect {|c| c.tidy}.length.should == 3
    end
    
    it "should cycle depth-first through the tree" do
      @myQ.collect {|c| c.tidy}[2].should == "do b"
    end
  end
end
