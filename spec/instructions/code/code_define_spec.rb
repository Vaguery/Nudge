#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeDefineInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDefineInstruction.new(@context)
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
      @i1 = CodeDefineInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :name stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:name].push(ReferencePoint.new("a"))
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        lambda{@i1.preconditions?}.should_not raise_error
        @context.stacks[:name].pop
        lambda{@i1.preconditions?}.should raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should assign the top code item's parsed ProgramPoint in the name hash" do
        @context.stacks[:name].push(ReferencePoint.new("a1"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do it}"))
        @context.names["a1"].should == nil
        @i1.go
        @context.stacks[:code].depth.should == 0
        @context.stacks[:name].depth.should == 0
        @context.names["a1"].should be_a_kind_of(CodeblockPoint)
        @context.names["a1"].listing.should == "block {\n  do it}"
      end
      
      it "should re-assign the binding if there already is one" do
        @context.stacks[:name].push(ReferencePoint.new("b2"))
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing"))
        @context.names["b2"] = CodeblockPoint.new([])
        @i1.go
        @context.stacks[:code].depth.should == 0
        @context.stacks[:name].depth.should == 0
        @context.names["b2"].should be_a_kind_of(InstructionPoint)
        @context.names["b2"].listing.should == "do nothing"
      end
      
      it "should not work if the name is a variable (as opposed to a local)" do
        @context.stacks[:name].push(ReferencePoint.new("c3"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @context.variables["c3"] = CodeblockPoint.new([])
        @i1.go
        @context.stacks[:error].depth.should == 1
      end
      
      it "should work for unparseable code values" do
        @context.stacks[:name].push(ReferencePoint.new("c3"))
        @context.stacks[:code].push(ValuePoint.new("code", "some random crap"))
        @i1.go
        @context.names["c3"].should == nil
        @context.stacks[:error].depth.should == 1
        @context.stacks[:error].peek.value.should include "code_define cannot parse"
      end
    end
  end
end
