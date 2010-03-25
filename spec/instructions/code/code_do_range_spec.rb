#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeDoRangeInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDoRangeInstruction.new(@context)
  end
    
  describe "\#go" do
    before(:each) do
      @i1 = CodeDoRangeInstruction.new(@context)
      @context.reset("block {}")
      @context.enable(CodeDoRangeInstruction)
      @context.enable(ExecDoRangeInstruction)
    end
    
    describe "\#preconditions?" do
      it "should check that there are two :ints and at least one :code item" do
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:code].push(ValuePoint.new("code", "ref x1"))
        @i1.preconditions?.should == true
      end
      
      it "should check that the ExecDoRangeInstruction is enabled" do
        @context.disable(ExecDoRangeInstruction)
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:code].push(ValuePoint.new("code", "ref x1"))
        lambda{@i1.preconditions?}.should raise_error
        @context.enable(ExecDoRangeInstruction)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset
      end
      
      it "should finish if the :ints are identical, pushing an :int and a copy of the codeblock" do
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:code].push(ValuePoint.new("code", "ref x1"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 3
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.listing.should == "ref x1"
      end
      
      it "should increment the counter if the counter < destination, and push a bunch of stuff" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:code].push(ValuePoint.new("code", "ref x2"))
        @i1.go
        
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 1
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing.should == "ref x2"
        @context.stacks[:exec].entries[0].listing.should == "block {\n  value «int»\n  value «int»\n  do exec_do_range\n  ref x2} \n«int» 2\n«int» 3"
        
        @context.run # get 'er done
        
        @context.stacks[:int].depth.should == 3
        @context.stacks[:int].peek.value.should == 3
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:name].depth.should == 3
      end
      
      it "should decrement the counter if the counter > destination, and push a bunch of stuff" do
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:int].push(ValuePoint.new("int", -12))
        @context.stacks[:code].push(ValuePoint.new("code", "ref x3"))
        @i1.go
        
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 2
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing.should == "ref x3"
        @context.stacks[:exec].entries[0].listing.should == "block {\n  value «int»\n  value «int»\n  do exec_do_range\n  ref x3} \n«int» 1\n«int» -12"
        
        @context.run # get 'er done
        
        @context.stacks[:int].depth.should == 15
        @context.stacks[:int].peek.value.should == -12
        
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:name].depth.should == 15
        (@context.stacks[:name].entries.collect {|e| e.value}).uniq.should == ["x3"]
      end
      
      it "should 'continue' until counter and destination are the same value" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @context.stacks[:int].push(ValuePoint.new("int", 100))
        @context.stacks[:code].push(ValuePoint.new("code", "value «float» \n«float» 1.1"))
        
        @i1.go
        @context.run # finish it off
        @context.stacks[:int].depth.should == 100
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:float].depth.should == 100
      end
    end
  end
end
