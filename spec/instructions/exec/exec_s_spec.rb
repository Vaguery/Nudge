#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe ExecSInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecSInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = ExecSInstruction.new(@context)
      @context.reset("block { do int_add do int_subtract do int_multiply}")
      @context.step # unwrapping the three instructions
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least three items" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should result in the top one [replaced], the old 3rd one, then a block with the 2nd and 3rd" do
        @context.stacks[:exec].depth.should == 3
        @i1.go
        @context.stacks[:exec].depth.should == 3
        @context.stacks[:exec].entries[2].tidy.should == "do int_add" # old top one
        @context.stacks[:exec].entries[1].tidy.should == "do int_multiply" # old 3rd one
        @context.stacks[:exec].entries[0].tidy.should == "block {\n  do int_subtract\n  do int_multiply}"
      end
    end
  end
end
