#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeDoCountInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDoCountInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @i1 = CodeDoCountInstruction.new(@context)
      @context.reset
      @context.enable(CodeDoCountInstruction)
      @context.enable(ExecDoRangeInstruction)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and 1 :code item" do
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:code].push(ValuePoint.new("code", "ref b1"))
        @i1.preconditions?.should == true
      end
      
      it "should check that the @context knows about exec_do_range" do
        @context.disable(ExecDoRangeInstruction)
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:code].push(ValuePoint.new("code", "ref b1"))
        lambda{@i1.preconditions?}.should raise_error
        @context.enable(ExecDoRangeInstruction)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset
        @context.enable(CodeDoCountInstruction)
        @context.enable(ExecDoRangeInstruction)
      end
      
      it "should create an :error entry if the int is negative or zero" do
        @context.stacks[:int].push(ValuePoint.new("int", -9182))
        @context.stacks[:code].push(ValuePoint.new("code", "ref b2"))
        @i1.go
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:error].peek.value.should == "code_do_count needs a positive argument"
        
        @context.reset
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @context.stacks[:code].push(ValuePoint.new("code", "ref b3"))
        @i1.go
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:error].peek.value.should == "code_do_count needs a positive argument"
      end
      
      it "should push a 0 onto :int, and an exec_do_range block onto :exec" do
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:code].push(ValuePoint.new("code", "ref b4"))
        @i1.go
        
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].entries[0].listing.should ==
          "block {\n  value «int»\n  value «int»\n  do exec_do_range\n  ref b4} \n«int» 0\n«int» 2"
          
        @context.run
        @context.stacks[:int].depth.should == 3
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:name].depth.should == 3
      end
    end
  end
end
