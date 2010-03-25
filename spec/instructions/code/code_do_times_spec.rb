#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeDoTimesInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDoTimesInstruction.new(@context)
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
      @i1 = CodeDoTimesInstruction.new(@context)
      @context.reset
      @context.enable(CodeDoTimesInstruction)
      @context.enable(ExecDoTimesInstruction)
    end
    
    describe "\#preconditions?" do
      it "should check that there are two :ints and at least one :code item" do
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing_now"))
        @i1.preconditions?.should == true
      end
      
      it "should check that ExecDoTimesInstruction is enabled" do
        @context.disable(ExecDoTimesInstruction)
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing_now"))
        lambda{@i1.preconditions?}.should raise_error
        @context.enable(ExecDoTimesInstruction)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset
      end
      
      it "should finish if the :ints are identical, leaving only a copy of the codeblock" do
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing_now"))
        
        @i1.go
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.listing.should == "do nothing_now"
      end
      
      it "should increment the counter if the counter < destination, and push a bunch of stuff" do
        @context.stacks[:int].push(ValuePoint.new("int", 7))
        @context.stacks[:int].push(ValuePoint.new("int", 9))
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing_now"))
        @i1.go
        
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[1].listing.should == "do nothing_now"
        @context.stacks[:exec].entries[0].listing.should ==
          "block {\n  value «int»\n  value «int»\n  do exec_do_times\n  do nothing_now} \n«int» 8\n«int» 9"
      end
      
      it "should run the number of times specified" do
        @context.stacks[:int].push(ValuePoint.new("int", 7))
        @context.stacks[:int].push(ValuePoint.new("int", 9))
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing_now"))
        @i1.go
        @context.run
        
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:error].depth.should == 3
        @context.stacks[:error].peek.value.should include("NothingNowInstruction is not")
      end
      
      it "should decrement the counter if the counter > destination, and push a bunch of stuff" do
        @context.stacks[:code].push(ValuePoint.new("code","value «float»\n«float» 0.1"))
        @context.stacks[:int].push(ValuePoint.new("int", -11))
        @context.stacks[:int].push(ValuePoint.new("int", -19))
        @i1.go
        
        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].entries[0].listing.should include "\n«int» -12\n«int» -19\n«float» 0.1"
        
        @context.run

        @context.stacks[:int].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:float].depth.should == 9
        @context.stacks[:float].peek.value.should == 0.1
      end
      
      it "should 'continue' until counter and destination are the same value" do
        @context.stacks[:int].push(ValuePoint.new("int", 11001))
        @context.stacks[:int].push(ValuePoint.new("int", 11100))
        @context.stacks[:code].push(ValuePoint.new("code","value «float»\n«float» 0.9"))
        @i1.go
        @context.run # finish it off
        @context.stacks[:float].depth.should == 100
        @context.stacks[:exec].depth.should == 0
      end
    end
  end
end
