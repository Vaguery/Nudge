#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeListInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeListInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeListInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a new block containing the two :code items' code, in order" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_wha"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref huh"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do int_wha\n  ref huh}"
      end
      
      it "should work with footnotes correctly" do
        @context.stacks[:code].push(ValuePoint.new("code", "value «foo»\n«foo» bar"))
        @context.stacks[:code].push(ValuePoint.new("code",
          "block{value «foo» value «bun»}\n«foo» baz\n«bun» qux"))
        @i1.go
        @context.stacks[:code].peek.value.should include("\n«foo» bar\n«foo» baz\n«bun» qux")
      end
    end
  end
end
