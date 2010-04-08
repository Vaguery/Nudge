require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe NameRotateInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = NameRotateInstruction.new(@context)
  end
  

  describe "\#go" do
    before(:each) do
      @i1 = NameRotateInstruction.new(@context)
      @name1 = ReferencePoint.new("name_1")
    end

    describe "\#preconditions?" do
      it "should check that there are enough parameters" do
        3.times {@context.stacks[:name].push(@name1)}
        @i1.preconditions?.should == true
      end
      
      it "should raise an error if the preconditions aren't met" do
        @context.clear_stacks # there are no params at all
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
      
      it "should successfully run #go only if all preconditions are met" do
        3.times {@context.stacks[:name].push(@name1)}
        @i1.should_receive(:cleanup)
        @i1.go
      end
    end
    
    describe "\#derive" do
      it "should pop all the arguments" do
        3.times {@context.stacks[:name].push(@name1)}
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        @context.stacks[:name].depth.should == 0
      end
    end
    
    describe "\#cleanup" do
      it "should move around the top three values" do
        @context.stacks[:name].push(ReferencePoint.new("name_3"))
        @context.stacks[:name].push(ReferencePoint.new("name_2"))
        @context.stacks[:name].push(ReferencePoint.new("name_1"))
        @i1.go
        @context.pop_value(:name).should == "name_3"
        @context.pop_value(:name).should == "name_1"
        @context.pop_value(:name).should == "name_2"
      end
    end
  end
end
