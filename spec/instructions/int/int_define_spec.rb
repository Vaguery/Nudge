require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe IntDefineInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntDefineInstruction.new(@context)
  end
  
  it "should check its context is set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = IntDefineInstruction.new(@context)
      @context.clear_stacks
      @name1 = ReferencePoint.new("xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :int" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:int].push(ValuePoint.new("int", 123))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :int to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:int].push(ValuePoint.new("int", 123))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:int].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 123
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", ValuePoint.new("bool", false))
        @context.names["xyz"].value.should == false
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:int].push(ValuePoint.new("int", 123))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:int].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 123
      end
      
      it "should not re-bind a name that is a variable, though" do
        @context.bind_variable("xyz", ValuePoint.new("bool", false))
        @context.stacks[:int].push(ValuePoint.new("int", 456))
        @context.stacks[:name].push(ReferencePoint.new("xyz"))
        @i1.go
        @context.stacks[:error].peek.listing.should include("cannot redefine a variable")
      end
      
      it "should raise an exception if it's binding the name to anything but a ValuePoint" do
        @context.stacks[:int].push(9912) #the actual number
        @context.stacks[:name].push(@name1)
        lambda{@i1.go}.should raise_error
      end
    end
  end
end
