#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeExecuteThenPopInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeExecuteThenPopInstruction.new(@context)
  end
    
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @context.enable(CodePopInstruction)
      @i1 = CodeExecuteThenPopInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.enable(CodePopInstruction)
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
      
      it "should need CodePopInstruction to be enabled" do
        @context.disable(CodePopInstruction)
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        lambda{@i1.preconditions?}.should raise_error
        @context.enable(CodePopInstruction)
        lambda{@i1.preconditions?}.should_not raise_error
      end
      
    end
    
    describe "\#cleanup" do
      it "should push a new block based on the code from the top of the :code stack" do
        @context.stacks[:code].push(ValuePoint.new("code", "do foo_bar"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {\n  do foo_bar\n  do code_pop}"
        @context.stacks[:exec].peek.should be_a_kind_of(CodeblockPoint)
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref x}"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {\n  block {\n    ref x}\n  do code_pop}"
        @context.stacks[:exec].peek.should be_a_kind_of(CodeblockPoint)
      end
      
      it "push a block containing 'do code_pop' if the code point can't be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "whatever you say boss"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {\n  do code_pop}"
      end
    end
  end
end
