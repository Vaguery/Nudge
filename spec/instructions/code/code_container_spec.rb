#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeContainerInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeContainerInstruction.new(@context)
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
      @i1 = CodeContainerInstruction.new(@context)
      @context.reset
    end
    
    describe "\#preconditions?" do
      it "should check that there is at least two :code items" do
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset
      end
      
      it "should copy the point from the 'haystack' that contains the 'needle' as a point in it" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref x"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref x}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref x}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block { block {do a}}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code",
          "block { block { block {do b} do c} block {block { do a do b}}}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a\n  do b}"
      end
      
      it "should return an empty block if it's not found" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref x"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
      end
      
      # "but is not equal to"
      it "should return an empty block if the two code chunks are identical" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
      end
      
      it "should work as expected for unparseable code" do
        @context.stacks[:code].push(ValuePoint.new("code", "hee hee haw haw"))
        @context.stacks[:code].push(ValuePoint.new("code", "now is the time for all good men"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
      end
    end
  end
end
