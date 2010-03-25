require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe FloatDepthInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatDepthInstruction.new(@context)
  end
  
  it "should have its context set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatDepthInstruction.new(@context)
      @context.clear_stacks
      @float1 = ValuePoint.new("float", 1)
    end
    
    describe "\#preconditions?" do
      it "should check that the :float stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should count the items on the stack and push it onto the :int stack" do
        @context.stacks[:int].depth.should == 0
        @i1.go # there are no floats
        @context.stacks[:int].peek.value.should == 0
        7.times {@context.stacks[:float].push @float1}
        @i1.go
        @context.stacks[:int].peek.value.should == 7
      end
    end
  end
end
