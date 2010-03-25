require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe FloatDefineInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatDefineInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = FloatDefineInstruction.new(@context)
      @context.clear_stacks
      @name1 = ReferencePoint.new("xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :float" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:float].push(ValuePoint.new("float", -11.11))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :float to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:float].push(ValuePoint.new("float", -11.11))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:float].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should be_close(-11.11,0.00001)
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", ValuePoint.new("int", 999))
        @context.names["xyz"].value.should == 999
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:float].push(ValuePoint.new("float", -11.11))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:float].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == -11.11
      end
      
      it "should not re-bind a name that is a variable, though" do
        @context.bind_variable("xyz", ValuePoint.new("bool", false))
        @context.stacks[:float].push(ValuePoint.new("float", 4.56))
        @context.stacks[:name].push(ReferencePoint.new("xyz"))
        @i1.go
        @context.stacks[:error].depth.should == 1
      end
      
    end
  end
end
