#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


# EXEC.DO*COUNT: An iteration instruction that performs a loop (the body of which is taken from the EXEC stack) the number of times indicated by the INTEGER argument, pushing an index (which runs from zero to one less than the number of iterations) onto the INTEGER stack prior to each execution of the loop body. This is similar to CODE.DO*COUNT except that it takes its code argument from the EXEC stack. This should be implemented as a macro that expands into a call to EXEC.DO*RANGE. EXEC.DO*COUNT takes a single INTEGER argument (the number of times that the loop will be executed) and a single EXEC argument (the body of the loop). If the provided INTEGER argument is negative or zero then this becomes a NOOP. Otherwise it expands into: ( 0 <1 - IntegerArg> EXEC.DO*RANGE <ExecArg> )


describe ExecDoCountInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecDoCountInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = ExecDoCountInstruction.new(@context)
      @context.reset("block {}")
      @context.enable(ExecDoCountInstruction)
      @context.enable(ExecDoRangeInstruction)
    end
    
    describe "\#preconditions?" do
      it "should check that there are two :ints, 1+ :exec item, and knows ExecDoRangeInstruction" do
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:exec].push(ReferencePoint.new("x"))
        @i1.preconditions?.should == true
      end
      
      it "should check that the @context knows about exec_do_range" do
        @context.disable(ExecDoRangeInstruction)
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        lambda{@i1.go}.should_not raise_error
        @context.stacks[:error].peek.listing.should include(
          "ExecDoCountInstruction needs ExecDoRangeInstruction")
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset("block {}")
        @context.enable(ExecDoRangeInstruction)
      end
      
      it "should create an :error entry if the int is negative or zero" do
        @context.stacks[:int].push(ValuePoint.new("int", -213))
        @i1.go
        @context.stacks[:exec].depth.should == 0
        
        @context.reset("block {}")
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @i1.go
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 0
      end
      
      it "should push a 0 onto :int, and an exec_do_range block onto :exec" do
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @i1.go
        
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].entries[0].listing_parts.should ==
          ["block {\n  value «int»\n  value «int»\n  do exec_do_range\n  block {}}",
            "«int» 0\n«int» 2"]
            
        @context.run
        @context.stacks[:int].depth.should == 3
        @context.stacks[:exec].depth.should == 0
      end
    end
  end
end
