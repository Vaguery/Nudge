#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeConcatenateInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeConcatenateInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeConcatenateInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least two items on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a new concatenated block containing the two :code items' code, in order" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a do b}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a\n  do b\n  do c}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {block {do a}}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {block {do b}}"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  block {\n    do a}\n  block {\n    do b}}"
      end
      
      it "should append #2 to #1, if 2 is an atom and 1 a block" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a do b}"))
        @context.stacks[:code].push(ValuePoint.new("code", "do c"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a\n  do b\n  do c}"
      end
      
      it "should wrap #1 and #2 if #1 isn't a block" do
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code", "do b"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a\n  do b}"
      end
      
      it "should work with footnotes correctly" do
        @context.stacks[:code].push(ValuePoint.new("code", "value «a»\n«a» 1"))
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  value «a»\n  value «b»} \n«a» 1\n«b» 2"
      end
      
      it "should return an empty block if either arg is unparseable" do
        @context.stacks[:code].push(ValuePoint.new("code", "i got nuthin"))
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @context.stacks[:code].push(ValuePoint.new("code", "no idea"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
      end
    end
  end
end
