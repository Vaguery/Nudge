#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeQuoteInstruction do
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeQuoteInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeQuoteInstruction.new(@context)
    end
    
    after(:each) do
      @context.clear_stacks
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :exec stack" do
        @context.stacks[:exec].push(ReferencePoint.new("hi_there"))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should the top thing from :exec onto the :code stack as a ValuePoint" do
        @context.stacks[:exec].push(ReferencePoint.new("hi_there"))
        @i1.go
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:code].depth.should == 1
        @context.stacks[:code].peek.value.should == "ref hi_there"
        
        @context.stacks[:exec].push(ValuePoint.new("lolcat","haz cheezburger"))
        @i1.go
        @context.stacks[:code].depth.should == 2
        @context.stacks[:code].peek.value.should == "value «lolcat» \n«lolcat» haz cheezburger"
        
        @context.stacks[:exec].push(CodeblockPoint.new([ReferencePoint.new("a"),InstructionPoint.new("b")]))
        @i1.go
        @context.stacks[:code].depth.should == 3
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  do b}"
        
      end
    end
  end
end
