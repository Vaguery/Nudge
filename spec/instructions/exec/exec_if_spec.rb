require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecIfInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecIfInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @context.reset
      @context.enable(ExecIfInstruction)
      @i1 = ExecIfInstruction.new(@context)
      @v1 = ValuePoint.new("float",  1.0)
      @v2 = ValuePoint.new("float", -9.5)
    end

    describe "\#preconditions?" do
      it "should check that there are two items on the target stack and at least one :bool" do
        @context.stacks[:exec].push(@v1)
        @context.stacks[:exec].push(@v2)
        @context.stacks[:bool].push(ValuePoint.new("bool", true))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should keep the SECOND :exec item if the :bool is true, otherwise the top one" do
        @context.stacks[:exec].push(@v1)
        @context.stacks[:exec].push(@v2)
        @context.stacks[:bool].push(ValuePoint.new("bool", true))
        @i1.go
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.value.should == 1.0
        
        @context.stacks[:exec].push(@v1)
        @context.stacks[:exec].push(@v2)
        @context.stacks[:bool].push(ValuePoint.new("bool", false))
        @i1.go
        @context.stacks[:exec].peek.value.should == -9.5
      end
    end
  end
end
