#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeDiscrepancyInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDiscrepancyInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = CodeDiscrepancyInstruction.new(@context)
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
      
      it "should calculate the summed absolute difference in counts of all points in both programs" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref x"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref y"))
        @i1.go
        @context.stacks[:int].peek.value.should == 2
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y}"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref y"))
        @i1.go
        @context.stacks[:int].peek.value.should == 1
        
        @context.stacks[:code].push(ValuePoint.new("code", "do x"))
        @context.stacks[:code].push(ValuePoint.new("code", "do x"))
        @i1.go
        @context.stacks[:int].peek.value.should == 0
      end
      
      it "should sum occurrences of different items, not just unique parts" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {do x do x do x do x}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do y}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 7
      end
      
      it "should work as you would expect for NilPoint (unparseable) programs" do
        @context.stacks[:code].push(ValuePoint.new("code", "some weird crap"))
        @context.stacks[:code].push(ValuePoint.new("code", "nothing here either"))
        @i1.go
        @context.stacks[:int].peek.value.should == 0
        
        @context.stacks[:code].push(ValuePoint.new("code", "do real_program_stuff"))
        @context.stacks[:code].push(ValuePoint.new("code", "refx")) # unparseable
        @i1.go
        @context.stacks[:int].peek.value.should == 1
      end
      
      it "should not depend on typographic differences" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y value «int» \n«int» 91}"))
        @context.stacks[:code].push(ValuePoint.new("code",
          "block   {\n  ref  y \tvalue    «int» \n\n«int»  \t91}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 0
      end
    end
  end
end
