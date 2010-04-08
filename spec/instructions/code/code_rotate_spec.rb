require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeRotateInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeRotateInstruction.new(@context)
  end
  

  describe "\#go" do
    before(:each) do
      @i1 = CodeRotateInstruction.new(@context)
      @code1 = ValuePoint.new("code", "ref a")
    end

    describe "\#preconditions?" do
      it "should check that there are enough parameters" do
        3.times {@context.stacks[:code].push(@code1)}
        @i1.preconditions?.should == true
      end
      
      it "should raise an error if the preconditions aren't met" do
        @context.clear_stacks # there are no params at all
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
      
      it "should successfully run #go only if all preconditions are met" do
        3.times {@context.stacks[:code].push(@code1)}
        @i1.should_receive(:cleanup)
        @i1.go
      end
    end
    
    describe "\#derive" do
      it "should pop all the arguments" do
        3.times {@context.stacks[:code].push(@code1)}
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        @context.stacks[:code].depth.should == 0
      end
    end
    
    describe "\#cleanup" do
      it "should move around the top three values" do
        @context.push(:code,"ref c")
        @context.push(:code,"ref b")
        @context.push(:code,"ref a")
        @i1.go
        @context.pop_value(:code).should == "ref c"
        @context.pop_value(:code).should == "ref a"
        @context.pop_value(:code).should == "ref b"
      end
    end
  end
end
