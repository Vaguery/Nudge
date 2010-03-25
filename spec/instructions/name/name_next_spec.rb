require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe NameNextInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameNextInstruction.new(@context)
  end
  
  it "should have a context upon creation" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
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
