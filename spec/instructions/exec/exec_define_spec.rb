require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecDefineInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecDefineInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = ExecDefineInstruction.new(@context)
      @context.clear_stacks
      @name1 = ReferencePoint.new("xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :exec item" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:exec].push(CodeblockPoint.new([]))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :exec item to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:exec].push(CodeblockPoint.new([]))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].blueprint.should == "block {}"
        @context.names["xyz"].should be_a_kind_of(CodeblockPoint)
        
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", ValuePoint.new("int", 999))
        @context.names["xyz"].value.should == 999
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:exec].push(ValuePoint.new("int", 22))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 22
      end
      
      it "should not re-bind a name that is a variable, though" do
        @context.bind_variable("xyz", ValuePoint.new("bool", false))
        @context.stacks[:exec].push(ValuePoint.new("int", 456))
        @context.stacks[:name].push(ReferencePoint.new("xyz"))
        @i1.go
        @context.stacks[:error].depth.should == 1
      end
    end
  end
end