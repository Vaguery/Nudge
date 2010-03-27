require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge

describe NameUnbindInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = NameUnbindInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = NameUnbindInstruction.new(@context)
      @context.clear_stacks
      @name1 = ReferencePoint.new("xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name" do
        @context.stacks[:name].push(@name1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset
        @name1 = ReferencePoint.new("xyz")
      end
      
      it "should remove the binding of the name if it exists" do
        @context.stacks[:name].push(@name1)
        @context.bind_name("xyz", ValuePoint.new("int", 9))
        @context.names["xyz"].value.should == 9
        @i1.go 
        @context.names.keys.should_not include("xyz")
      end
      
      it "should not affect variables at all" do
        @context.stacks[:name].push(@name1)
        @context.bind_variable("xyz", ValuePoint.new("int", 9))
        @context.bind_name("xyz", ValuePoint.new("int", 99))
        @context.variables["xyz"].value.should == 9
        @context.names["xyz"].value.should == 99
        @i1.go 
        @context.variables.keys.should include("xyz")
        @context.names.keys.should_not include("xyz")
      end
      
      it "should not create an error if it tries to unbind an unknown name" do
        @context.stacks[:name].push(@name1)
        @context.bind_name("abc", ValuePoint.new("int", 99))
        @i1.go 
        @context.names.keys.should include("abc")
        @context.stacks[:error].depth.should == 0
      end
    end
  end
end
