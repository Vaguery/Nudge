#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge



describe CodeReplaceNthPointInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeReplaceNthPointInstruction.new(@context)
  end
  
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeReplaceNthPointInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :int stack and two on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a_1 ref b_1 ref c_1}"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
      end
      
      it "should replace a point in the top code with the second code, at position indicated by the int" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @context.stacks[:code].push(ValuePoint.new("code", "do foo"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "do foo"
        
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:code].push(ValuePoint.new("code", "do foo"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do foo\n  ref b\n  ref c}"
        
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @context.stacks[:code].push(ValuePoint.new("code", "do foo"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  ref b\n  do foo}"
      end
      
      it "should use the int modulo the number of points in the top code" do
        @context.stacks[:int].push(ValuePoint.new("int", 0))
        @context.stacks[:code].push(ValuePoint.new("code", "do foo"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "do foo"
        
        @context.stacks[:int].push(ValuePoint.new("int", -2))
        @context.stacks[:code].push(ValuePoint.new("code", "do foo"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  do foo\n  ref c}"
        
        @context.stacks[:int].push(ValuePoint.new("int", 912152)) # 
        @context.stacks[:code].push(ValuePoint.new("code", "do foo"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "do foo"
      end
      
      it "should work well with footnotes" do
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:code].push(ValuePoint.new("code", "value «int» \n«int» 88"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a value «bool»}\n«bool» false"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  value «int»\n  value «bool»} \n«int» 88\n«bool» false"
          
        @context.stacks[:int].push(ValuePoint.new("int", 3))
        @context.stacks[:code].push(ValuePoint.new("code", "do x"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a value «bool»}\n«bool» false"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  do a\n  do x}"          
      end
      
      it "should raise an exception if either code string is unparseable" do
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:code].push(ValuePoint.new("code", "value «int» \n«int» 88"))
        @context.stacks[:code].push(ValuePoint.new("code", "some stupid junk"))
        @i1.go
        @context.stacks[:code].depth.should == 0
        @context.stacks[:error].peek.value.should ==
          "code_replace_nth_point cannot work with unparseable code"
        
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @context.stacks[:code].push(ValuePoint.new("code", "some other stupid junk"))
        @context.stacks[:code].push(ValuePoint.new("code", "value «int» \n«int» 88"))
        @i1.go
        @context.stacks[:code].depth.should == 0
        @context.stacks[:error].peek.value.should ==
          "code_replace_nth_point cannot work with unparseable code"
        
      end
    end
  end
end
