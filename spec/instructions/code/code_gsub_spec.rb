#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeGsubInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeGsubInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeGsubInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least three items on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "something"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a_1 ref b_1 ref c_1}"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
      end
      
      it "should substitute the third item on the code stack for the second item in the first item" do
        @context.stacks[:code].push(ValuePoint.new("code", "do x"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  do x\n  ref c}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "do x"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref c ref d}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a do b block {ref c ref d}}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a\n  do b\n  do x}"
      end
      
      it "should replace every occurrence in the tree" do
        @context.stacks[:code].push(ValuePoint.new("code", "do x"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a block {ref a} block { block {ref a}}}"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  do x\n  block {\n    do x}\n  block {\n    block {\n      do x}}}"
      end
      
      it "should cause an :error if any of the strings can't be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "some junk"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @i1.go
        @context.stacks[:error].peek.value.should == "code_gsub cannot work with unparseable code"
        
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        @context.stacks[:code].push(ValuePoint.new("code", "some junk"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @i1.go
        @context.stacks[:error].peek.value.should == "code_gsub cannot work with unparseable code"
        
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @context.stacks[:code].push(ValuePoint.new("code", "some junk"))
        @i1.go
        @context.stacks[:error].peek.value.should == "code_gsub cannot work with unparseable code"
      end
      
      it "should work with footnotes correctly" do
        @context.stacks[:code].push(ValuePoint.new("code", "value «int»\n«int» 81"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref g"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref g ref g}"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  value «int»\n  value «int»} \n«int» 81\n«int» 81"
        
        @context.stacks[:code].push(ValuePoint.new("code", "value «int»\n«int» 81"))
        @context.stacks[:code].push(ValuePoint.new("code", "value «foo»\n«foo» bar"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {value «foo»}\n«foo» bar"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  value «int»} \n«int» 81"
      end
      
      it "should return the original code if the substitution isn't found" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        @context.stacks[:code].push(ValuePoint.new("code", "do x"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  ref b}"
      end
      
      it "should not recurse!" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a}"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  block {\n    ref a}\n  ref b}"
      end
    end
  end
end
