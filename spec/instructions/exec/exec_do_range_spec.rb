#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecDoRangeInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecDoRangeInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = ExecDoRangeInstruction.new(@context)
      @context.reset("block {}")
      @context.enable(ExecDoRangeInstruction)
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
      
      it "should finish if the :ints are identical, pushing an :int and a copy of the codeblock" do
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 3
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.tidy.should == "block {}"
      end
      
      it "should increment the counter if the counter < destination, and push a bunch of stuff" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @i1.go
        
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 1
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing_parts.should == ["block {}",""]
        @context.stacks[:exec].entries[0].listing_parts.should == ["block {\n  value «int»\n  value «int»\n  do exec_do_range\n  block {}}","«int» 2\n«int» 3"]
        
        5.times {@context.step} # block {}; unwrap; push counter; push dest; run exec_do_range
        
        @context.stacks[:int].depth.should == 2
        @context.stacks[:int].peek.value.should == 2
        
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing_parts.should == ["block {}",""]
        @context.stacks[:exec].entries[0].listing_parts.should == ["block {\n  value «int»\n  value «int»\n  do exec_do_range\n  block {}}","«int» 3\n«int» 3"]
      end
      
      it "should decrement the counter if the counter > destination, and push a bunch of stuff" do
        @context.stacks[:int].push(ValuePoint.new("int", -2))
        @context.stacks[:int].push(ValuePoint.new("int", -19))
        @i1.go
        
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == -2
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing_parts.should == ["block {}",""]
        @context.stacks[:exec].entries[0].listing_parts.should == ["block {\n  value «int»\n  value «int»\n  do exec_do_range\n  block {}}","«int» -3\n«int» -19"]
        
        5.times {@context.step} # block {}; unwrap; push counter; push dest; run exec_do_range
        
        @context.stacks[:int].depth.should == 2
        @context.stacks[:int].peek.value.should == -3
        
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing_parts.should == ["block {}",""]
        @context.stacks[:exec].entries[0].listing_parts.should == ["block {\n  value «int»\n  value «int»\n  do exec_do_range\n  block {}}","«int» -4\n«int» -19"]
      end
      
      it "should 'continue' until counter and destination are the same value" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @context.stacks[:int].push(ValuePoint.new("int", 100))
        @i1.go
        @context.run # finish it off
        @context.stacks[:int].depth.should == 100
        @context.stacks[:exec].depth.should == 0
      end
    end
  end
end
