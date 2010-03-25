require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeIfInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeIfInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @context.reset
      @context.enable(CodeIfInstruction)
      @i1 = CodeIfInstruction.new(@context)
      @v1 = ValuePoint.new("code", "do my_thing")
      @v2 = ValuePoint.new("code", "ref some_x")
    end

    describe "\#preconditions?" do
      it "should check that there are two items on the target stack and at least one :bool" do
        @context.stacks[:code].push(@v1)
        @context.stacks[:code].push(@v2)
        @context.stacks[:bool].push(ValuePoint.new("bool", true))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should move the SECOND :code item to :exec if the :bool is true, otherwise the top one" do
        @context.stacks[:code].push(@v1)
        @context.stacks[:code].push(@v2)
        @context.stacks[:bool].push(ValuePoint.new("bool", true))
        @i1.go
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.should be_a_kind_of(InstructionPoint)
        @context.stacks[:code].depth.should == 0
        
        @context.stacks[:code].push(@v1)
        @context.stacks[:code].push(@v2)
        @context.stacks[:bool].push(ValuePoint.new("bool", false))
        @i1.go
        @context.stacks[:exec].peek.should be_a_kind_of(ReferencePoint)
      end
    end
  end
end

