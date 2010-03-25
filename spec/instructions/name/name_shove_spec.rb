require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe NameShoveInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameShoveInstruction.new(@context)
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
      @i1 = NameShoveInstruction.new(@context)
      @context.clear_stacks
      @name1 = ReferencePoint.new("abc")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :name" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:name].push(@name1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        11.times {@context.stacks[:name].push(@name1)}
        @context.stacks[:name].push(ReferencePoint.new("xyz")) # making it 12 deep
      end
      
      it "should not move the top item if the integer is negative" do
        @context.stacks[:int].push(ValuePoint.new("int", -99))
        @i1.go
        @context.stacks[:name].depth.should == 12
        @context.stacks[:name].peek.value.should == "xyz"
      end
      
      it "should not move the top item if the integer is zero" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:name].depth.should == 12
        @context.stacks[:name].peek.value.should == "xyz"
      end
      
      it "should move the top item farther down if the value is less than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 1000))
        @i1.go
        @context.stacks[:name].depth.should == 12
        @context.stacks[:name].entries[0].value.should == "xyz"
      end
      
      it "should move the top item to the bottom if the value is more than the depth" do
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:name].depth.should == 12
        @context.stacks[:name].entries[11].value.should == "abc"
        @context.stacks[:name].entries[7].value.should == "xyz"
      end
    end
  end
end
