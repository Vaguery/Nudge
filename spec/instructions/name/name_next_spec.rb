require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe NameNextInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = NameNextInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = NameNextInstruction.new(@context)
      @context.reset
    end
    
    describe "\#preconditions?" do
      it "should always be ready to go" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should push a new ReferencePoint onto :exec, with an incremented value" do
        @context.last_name.should == "refAAAAA"
        @i1.go
        @context.last_name.should == "refAAAAB"
        @context.stacks[:exec].depth.should == 1
        @i1.go
        @context.last_name.should == "refAAAAC"
        @context.stacks[:exec].peek.value.should == "refAAAAC"
      end
    end
  end
end
