#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeNameLookupInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNameLookupInstruction.new(@context)
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
      @i1 = CodeNameLookupInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :name stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:name].push(ReferencePoint.new("a"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should get the top :name item & push its bound value onto the code stack as a new ValuePoint" do
        @context.stacks[:name].push(ReferencePoint.new("foo"))
        @context.names["foo"].should == nil
        @context.bind_name("foo", ValuePoint.new("int",1987))
        @context.names["foo"].listing.should == "value «int» \n«int» 1987"
        @i1.go
        @context.stacks[:code].depth.should == 1
        @context.stacks[:code].peek.listing.should == "value «code» \n«code» value «int» \n«int» 1987"
        @context.stacks[:name].depth.should == 0
      end
      
      it "should work for bindings to other ProgramPoint subclasses" do
        @context.stacks[:name].push(ReferencePoint.new("vja"))
        @context.names["vja"].should == nil
        @context.bind_name("vja", NudgeProgram.new("block {ref x do int_add block {ref y}}").linked_code)
        @context.names["vja"].listing.should == "block {\n  ref x\n  do int_add\n  block {\n    ref y}}"
        @i1.go
        @context.stacks[:code].depth.should == 1
        @context.stacks[:code].peek.listing.should ==
          "value «code» \n«code» block {\n  ref x\n  do int_add\n  block {\n    ref y}}"
        @context.stacks[:code].peek.should be_a_kind_of(ValuePoint)
        @context.stacks[:name].depth.should == 0
        
      end
      
      it "should return an empty «code» ValuePoint if there is no binding" do
        @context.stacks[:name].push(ReferencePoint.new("b2"))
        @i1.go
        @context.stacks[:code].depth.should == 1
        @context.stacks[:code].peek.listing.should == "value «code» \n«code»"
      end
    end
  end
end
