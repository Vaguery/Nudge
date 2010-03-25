require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe IntRandomInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = IntRandomInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = IntRandomInstruction.new(@context)
      @context.clear_stacks
    end
      
    describe "\#cleanup" do
      it "should invoke Type#any_value" do
        @context.clear_stacks
        IntType.should_receive(:any_value)
        @i1.go
      end
      
      it "should have a created a new instance of the right type and pushed it" do
        @context.clear_stacks
        @i1.go
        @context.stacks[:int].depth.should == 1
        result = @context.stacks[:int].peek
        result.value.should_not == nil
        result.type.should == :int
      end
    end
  end
end
