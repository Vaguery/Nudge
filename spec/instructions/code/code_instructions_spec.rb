#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeInstructionsInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeInstructionsInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeInstructionsInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "doesn't need any preconditions to be met, actually" do
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a block containing every active instruction" do
        @context.disable_all_instructions
        @context.enable(CodeInstructionsInstruction)
        @context.enable(IntAddInstruction)
        @i1.go
        @context.stacks[:code].peek.value.should == "block { do code_instructions do int_add}"
        
        @context.enable(ExecPopInstruction)
        @i1.go
        @context.stacks[:code].peek.value.should == "block { do code_instructions do int_add do exec_pop}"
      end
    end
  end
end
