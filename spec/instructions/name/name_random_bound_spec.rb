require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe NameRandomBoundInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameRandomBoundInstruction.new(@context)
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
      @i1 = NameRandomBoundInstruction.new(@context)
      @bar = ValuePoint.new("int", 99)
      @context.reset
    end
    
    describe "\#preconditions?" do
      it "should check that there are any bound variables or names" do
        @i1.preconditions?.should == false
        
        @context.bind_variable("d", @bar)
        @i1.preconditions?.should == true
        
        @context.reset_variables
        @context.bind_name("r", @bar)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should push a random sample of the bound references in @context" do
        @context.bind_variable("d", @bar)
        @i1.go
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.should be_a_kind_of(ReferencePoint)
        @context.stacks[:exec].peek.value.should == "d"
        
        @context.reset_variables
        @context.bind_name("e", @bar)
        @i1.go
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].peek.should be_a_kind_of(ReferencePoint)
        @context.stacks[:exec].peek.value.should == "e"
        
        @context.reset_names
        @i1.go # nothing should happen
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].peek.should be_a_kind_of(ReferencePoint)
        @context.stacks[:exec].peek.value.should == "e"
      end
    end
  end
end
