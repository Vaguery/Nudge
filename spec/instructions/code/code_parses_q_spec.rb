#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeParsesQInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeParsesQInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = CodeParsesQInstruction.new(@context)
      @context.reset
    end
    
    describe "\#preconditions?" do
      it "should check that there is at least one :code item" do
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset
      end
      
      it "should push a boolean 'false' if the top :code item can't be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "doint_add"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
      end
      
      it "should push a boolean 'true' value if the top :code item can be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "ref x"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "value «foo»\n«foo» bar"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "do some_weird_stuff"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
      end
      
      it "should push false if the top item has no code (is only footnotes)" do
        @context.stacks[:code].push(ValuePoint.new("code", " \n«foo» bar\n«baz» qux"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
      end
    end
  end
end
