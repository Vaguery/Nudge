require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe NameDisableLookupInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameDisableLookupInstruction.new(@context)
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
      @i1 = NameDisableLookupInstruction.new(@context)
      @bar = ValuePoint.new("int", 99)
      @context.bind_name("zzzz", @bar)
    end
    
    describe "\#preconditions?" do
      it "should always be ready to go" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should switch off channel lookup until one NAME is encountered" do
        3.times {@context.stacks[:exec].push(ReferencePoint.new("zzzz"))}
        
        @context.evaluate_references.should == true
        2.times {@context.step} # looks up 'zzzz', pushes to :exec; pushes to :int
        @context.stacks[:int].peek.value.should == 99
        
        @i1.go
        @context.evaluate_references.should == false
        
        @context.step # doesn't look it up, pushes ReferencePoint to :name
        @context.stacks[:name].peek.value.should == "zzzz"
        @context.evaluate_references.should == true
        2.times {@context.step} # looks up 'zzzz' again, pushes to :exec; pushes to :int
        @context.stacks[:int].depth.should == 2
      end
    end
  end
end
