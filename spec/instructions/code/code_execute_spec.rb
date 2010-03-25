#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeExecuteInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeExecuteInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeExecuteInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a ProgramPoint based on the code from the top of the :code stack" do
        @context.stacks[:code].push(ValuePoint.new("code", "do foo_bar"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "do foo_bar"
        @context.stacks[:exec].peek.should be_a_kind_of(InstructionPoint)
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref x}"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {\n  ref x}"
        @context.stacks[:exec].peek.should be_a_kind_of(CodeblockPoint)
        
      end
      
      it "push an empty block {} if the code point can't be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "whatever you say boss"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {}"
      end
    end
  end
end
