#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


# EXEC.DO*TIMES: Like EXEC.DO*COUNT but does not push the loop counter. This should be implemented as a macro that expands into EXEC.DO*RANGE, similarly to the implementation of EXEC.DO*COUNT, except that a call to INTEGER.POP should be tacked on to the front of the loop body code in the call to EXEC.DO*RANGE. This call to INTEGER.POP will remove the loop counter, which will have been pushed by EXEC.DO*RANGE, prior to the execution of the loop body.


describe ExecDoTimesInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecDoTimesInstruction.new(@context)
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
      @i1 = ExecDoTimesInstruction.new(@context)
      @context.reset("block {}")
      @context.enable(ExecDoTimesInstruction)
    end
    
    describe "\#preconditions?" do
      it "should check that there are two :ints and at least one :exec item" do
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset("block {}")
      end
      
      it "should finish if the :ints are identical, leaving only a copy of the codeblock" do
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @i1.go
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.tidy.should == "block {}"
      end
      
      it "should increment the counter if the counter < destination, and push a bunch of stuff" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @i1.go
        
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing_parts.should == ["block {}",""]
        @context.stacks[:exec].entries[0].listing_parts.should == [
          "block {\n  value «int»\n  value «int»\n  do exec_do_times\n  block {}}",
          "«int» 2\n«int» 3"]
        
        5.times {@context.step} # block {}; unwrap; push counter; push dest; run exec_do_range
        
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing_parts.should == ["block {}",""]
        @context.stacks[:exec].entries[0].listing_parts.should == [
          "block {\n  value «int»\n  value «int»\n  do exec_do_times\n  block {}}",
          "«int» 3\n«int» 3"]
      end
      
      it "should decrement the counter if the counter > destination, and push a bunch of stuff" do
        @context.reset("value «float»\n«float» 0.1")
        @context.stacks[:int].push(ValuePoint.new("int", -2))
        @context.stacks[:int].push(ValuePoint.new("int", -19))
        @i1.go
        
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing_parts.should == ["value «float»","«float» 0.1"]
        @context.stacks[:exec].entries[0].listing_parts.should == 
          ["block {\n  value «int»\n  value «int»\n  do exec_do_times\n  value «float»}",
            "«int» -3\n«int» -19\n«float» 0.1"]
        
        5.times {@context.step} # block {}; unwrap; push counter; push dest; run exec_do_times
        
        @context.stacks[:int].depth.should == 0
        @context.stacks[:float].depth.should == 1
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing_parts.should == ["value «float»","«float» 0.1"]
        @context.stacks[:exec].entries[0].listing_parts.should == 
          ["block {\n  value «int»\n  value «int»\n  do exec_do_times\n  value «float»}",
            "«int» -4\n«int» -19\n«float» 0.1"]
      end
      
      it "should 'continue' until counter and destination are the same value" do
        @context.reset("value «float»\n«float» 0.1")
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @context.stacks[:int].push(ValuePoint.new("int", 100))
        @i1.go
        @context.run # finish it off
        @context.stacks[:float].depth.should == 100
        @context.stacks[:exec].depth.should == 0
      end
    end
  end
end
