#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeCarInstruction do
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeCarInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeCarInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a new ValuePoint containing the first item from the top :code item's backbone block" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref a"
      end
      
      it "should leave the top item on the stack if it isn't a CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref z"))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref z"        
      end
      
      it "should leave the top item on the stack if it is an empty CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"        
      end
    end
  end
end
