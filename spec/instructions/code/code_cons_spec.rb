#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeConsInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeConsInstruction.new(@context)
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
      @i1 = CodeConsInstruction.new(@context)
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
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  ref b}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a}"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  block {\n    ref a}\n  ref b}"
      end
      
      it "should raise an exception if either code item can't be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "somethin' weird"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @i1.go
        @context.stacks[:code].depth.should == 0
        @context.stacks[:error].peek.value.should == "code_cons cannot parse the arguments"
      end
      
      it "should work with footnotes" do
        @context.stacks[:code].push(ValuePoint.new("code", "value «int»\n«int» 7771"))
        @context.stacks[:code].push(ValuePoint.new("code", "value «int»\n«int» 1117"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  value «int»\n  value «int»} \n«int» 7771\n«int» 1117"
      end
    end
  end
end
