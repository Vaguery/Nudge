require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe BoolDefineInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = BoolDefineInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = BoolDefineInstruction.new(@context)
      @context.clear_stacks
      @name1 = ReferencePoint.new("xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :bool" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:bool].push(ValuePoint.new("bool", false))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :bool to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:bool].push(ValuePoint.new("bool", false))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:bool].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == false
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", ValuePoint.new("float", 3.3))
        @context.names["xyz"].value.should == 3.3
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:bool].push(ValuePoint.new("bool", false))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:bool].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == false
      end
      
      it "should not re-bind a name that is a variable, though" do
        @context.bind_variable("xyz", ValuePoint.new("bool", false))
        @context.stacks[:bool].push(ValuePoint.new("bool", 456))
        @context.stacks[:name].push(ReferencePoint.new("xyz"))
        @i1.go
        @context.stacks[:error].peek.blueprint.should include "cannot redefine a variable"
      end
      
    end
  end
end
