require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe NameFlushInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameFlushInstruction.new(@context)
  end
  
  it "should have its context set right" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = NameFlushInstruction.new(@context)
      @context.clear_stacks
      @name1 = ReferencePoint.new("xx")
    end
    
    describe "\#preconditions?" do
      it "should check that the :int stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should remove all items on the stack" do
        11.times {@context.stacks[:name].push(@name1)}
        @context.stacks[:name].depth.should == 11
        @i1.go
        @context.stacks[:name].depth.should == 0
      end
    end
  end
end
