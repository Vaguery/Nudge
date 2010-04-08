require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe NameDuplicateInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = NameDuplicateInstruction.new(@context)
  end
  

  describe "\#go" do
    before(:each) do
      @i1 = NameDuplicateInstruction.new(@context)
      @name1 = ReferencePoint.new("my_name")
    end

    describe "\#preconditions?" do
      it "should check that there are enough parameters" do
        2.times {@context.stacks[:name].push(@name1)}
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
    
    
    describe "\#cleanup" do
      it "should swap the top two values" do
        @context.stacks[:name].push(@name1)
        @i1.go
        @context.depth(:name).should == 2
        @context.pop_value(:name).should == "my_name"
        @context.pop_value(:name).should == "my_name"
      end
    end
  end
end
