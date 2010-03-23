#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe CodeNoopInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNoopInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeNoopInstruction.new(@context)
    end

    describe "\#preconditions?" do
      it "should not need any items on any stacks" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should change nothing about the interpreter except the step count" do
        @context = Interpreter.new(program:"do code_noop")
        @context.enable(CodeNoopInstruction)
        earlier = @context.steps
        @context.run
        @context.steps.should == (earlier+1)
        @context.stacks.each {|k,v| v.depth.should == 0}
      end
    end
  end
end


describe CodeNullQInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNullQInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeNullQInstruction.new(@context)
    end

    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should push a :bool that is false when the :code value isn't 'block {}'" do
        @context.stacks[:code].push(ValuePoint.new("code","ref x"))
        @i1.go
        @context.stacks[:bool].depth.should == 1
        @context.stacks[:bool].peek.value.should == false
      end
      
      it "should push a :bool that's true when the top :code item is 'block {}" do
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.go
        @context.stacks[:bool].depth.should == 1
        @context.stacks[:bool].peek.value.should == true
      end
    end
  end
end



describe CodeAtomQInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeAtomQInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeAtomQInstruction.new(@context)
    end

    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.stacks[:code].push(ValuePoint.new("code","ref a"))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should push a :bool indicating whether the :code value is an atom or not" do
        @context.stacks[:code].push(ValuePoint.new("code","ref x"))
        @i1.go
        @context.stacks[:bool].depth.should == 1
        @context.stacks[:code].depth.should == 0
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code","i have no idea"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code","block {ref a}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
      end
    end
  end
end



describe CodeQuoteInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeQuoteInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeQuoteInstruction.new(@context)
    end
    
    after(:each) do
      @context.clear_stacks
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :exec stack" do
        @context.stacks[:exec].push(ReferencePoint.new("hi_there"))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should the top thing from :exec onto the :code stack as a ValuePoint" do
        @context.stacks[:exec].push(ReferencePoint.new("hi_there"))
        @i1.go
        @context.stacks[:exec].depth.should == 0
        @context.stacks[:code].depth.should == 1
        @context.stacks[:code].peek.value.should == "ref hi_there"
        
        @context.stacks[:exec].push(ValuePoint.new("lolcat","haz cheezburger"))
        @i1.go
        @context.stacks[:code].depth.should == 2
        @context.stacks[:code].peek.value.should == "value «lolcat» \n«lolcat» haz cheezburger"
        
        @context.stacks[:exec].push(CodeblockPoint.new([ReferencePoint.new("a"),InstructionPoint.new("b")]))
        @i1.go
        @context.stacks[:code].depth.should == 3
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  do b}"
        
      end
    end
  end
end



describe CodePointsInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodePointsInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodePointsInstruction.new(@context)
    end

    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should push an :int that is the count of points in the top :code item" do
        @context.stacks[:code].push(ValuePoint.new("code","ref x"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 1
        
        @context.stacks[:code].push(ValuePoint.new("code","block {ref a ref b ref c ref d block {ref ee}}"))
        @i1.go
        @context.stacks[:int].depth.should == 2
        @context.stacks[:int].peek.value.should == 7
      end
      
      it "should count non-parsing programs as having 0 points" do
        @context.stacks[:code].push(ValuePoint.new("code","I have no idea whatsoever"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 0
      end
    end
  end
end


describe CodeDefineInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDefineInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeDefineInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :name stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:name].push(ReferencePoint.new("a"))
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        lambda{@i1.preconditions?}.should_not raise_error
        @context.stacks[:name].pop
        lambda{@i1.preconditions?}.should raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should assign the top code item's parsed ProgramPoint in the name hash" do
        @context.stacks[:name].push(ReferencePoint.new("a1"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do it}"))
        @context.names["a1"].should == nil
        @i1.go
        @context.stacks[:code].depth.should == 0
        @context.stacks[:name].depth.should == 0
        @context.names["a1"].should be_a_kind_of(CodeblockPoint)
        @context.names["a1"].listing.should == "block {\n  do it}"
      end
      
      it "should re-assign the binding if there already is one" do
        @context.stacks[:name].push(ReferencePoint.new("b2"))
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing"))
        @context.names["b2"] = CodeblockPoint.new([])
        @i1.go
        @context.stacks[:code].depth.should == 0
        @context.stacks[:name].depth.should == 0
        @context.names["b2"].should be_a_kind_of(InstructionPoint)
        @context.names["b2"].listing.should == "do nothing"
      end
      
      it "should not work if the name is a variable (as opposed to a local)" do
        @context.stacks[:name].push(ReferencePoint.new("c3"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @context.variables["c3"] = CodeblockPoint.new([])
        @i1.go
        @context.stacks[:error].depth.should == 1
      end
      
      it "should work for unparseable code values" do
        @context.stacks[:name].push(ReferencePoint.new("c3"))
        @context.stacks[:code].push(ValuePoint.new("code", "some random crap"))
        @i1.go
        @context.names["c3"].should == nil
        @context.stacks[:error].depth.should == 1
        @context.stacks[:error].peek.value.should include "code_define cannot parse"
      end
    end
  end
end


describe CodeNameLookupInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNameLookupInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeNameLookupInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :name stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:name].push(ReferencePoint.new("a"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should get the top :name item & push its bound value onto the code stack as a new ValuePoint" do
        @context.stacks[:name].push(ReferencePoint.new("foo"))
        @context.names["foo"].should == nil
        @context.bind_name("foo", ValuePoint.new("int",1987))
        @context.names["foo"].listing.should == "value «int» \n«int» 1987"
        @i1.go
        @context.stacks[:code].depth.should == 1
        @context.stacks[:code].peek.listing.should == "value «code» \n«code» value «int» \n«int» 1987"
        @context.stacks[:name].depth.should == 0
      end
      
      it "should work for bindings to other ProgramPoint subclasses" do
        @context.stacks[:name].push(ReferencePoint.new("vja"))
        @context.names["vja"].should == nil
        @context.bind_name("vja", NudgeProgram.new("block {ref x do int_add block {ref y}}").linked_code)
        @context.names["vja"].listing.should == "block {\n  ref x\n  do int_add\n  block {\n    ref y}}"
        @i1.go
        @context.stacks[:code].depth.should == 1
        @context.stacks[:code].peek.listing.should ==
          "value «code» \n«code» block {\n  ref x\n  do int_add\n  block {\n    ref y}}"
        @context.stacks[:code].peek.should be_a_kind_of(ValuePoint)
        @context.stacks[:name].depth.should == 0
        
      end
      
      it "should return an empty «code» ValuePoint if there is no binding" do
        @context.stacks[:name].push(ReferencePoint.new("b2"))
        @i1.go
        @context.stacks[:code].depth.should == 1
        @context.stacks[:code].peek.listing.should == "value «code» \n«code»"
      end
    end
  end
end



describe CodeNthInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNthInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeNthInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :int stack and :code stacks" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
      end
      
      it "should get the Nth item from the backbone of the top :code value" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref b"
      end
      
      it "should use the top :int modulo the length of the backbone" do
        @context.stacks[:int].push(ValuePoint.new("int", 11))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref c"        
      end
      
      it "should work for negative values too" do
        @context.stacks[:int].push(ValuePoint.new("int", -8172))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref a"
      end
      it "should return the top :code value itself if it's not a CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_rob"))
        @context.stacks[:int].push(ValuePoint.new("int", 21))
        @i1.go
        @context.stacks[:code].peek.value.should == "do int_rob"
        
      end
    end
  end
end



describe CodeCdrInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeCdrInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeCdrInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should remove the first item from the top :code item's backbone block" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref b\n  ref c}"
      end
      
      it "should push an empty block {} program if the item isn't a CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"        
      end
      
      it "should push an empty block {} program if the item doesn't have enough points to remove 1" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"        
      end
    end
  end
end



describe CodeNthPointInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeNthPointInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeNthPointInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :int stack and :code stacks" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a block {ref b ref c}}"))
      end
      
      it "should get the Nth point of the top :code value" do
        @context.stacks[:int].push(ValuePoint.new("int", 1))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref a\n  block {\n    ref b\n    ref c}}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a block {ref b ref c}}"))
        @context.stacks[:int].push(ValuePoint.new("int", 2))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref a"
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a block {ref b ref c}}"))
        @context.stacks[:int].push(ValuePoint.new("int", 4))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref b"
        
      end
      
      it "should use the top :int modulo the length of the backbone" do
        @context.stacks[:int].push(ValuePoint.new("int", 12))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref a"        
      end
      
      it "should work for negative values too" do
        @context.stacks[:int].push(ValuePoint.new("int", -6612))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref b\n  ref c}"
      end
    end
  end
end




describe CodeReplaceNthPointInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeReplaceNthPointInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
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




describe CodeCarInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeCarInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeCarInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a new ValuePoint containing the first item from the top :code item's backbone block" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref a ref b ref c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref a"
      end
      
      it "should leave the top item on the stack if it isn't a CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref z"))
        @i1.go
        @context.stacks[:code].peek.value.should == "ref z"        
      end
      
      it "should leave the top item on the stack if it is an empty CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"        
      end
    end
  end
end



describe CodeExecuteInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeExecuteInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeExecuteInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a ProgramPoint based on the code from the top of the :code stack" do
        @context.stacks[:code].push(ValuePoint.new("code", "do foo_bar"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "do foo_bar"
        @context.stacks[:exec].peek.should be_a_kind_of(InstructionPoint)
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref x}"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {\n  ref x}"
        @context.stacks[:exec].peek.should be_a_kind_of(CodeblockPoint)
        
      end
      
      it "push an empty block {} if the code point can't be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "whatever you say boss"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {}"
      end
    end
  end
end



describe CodeExecuteThenPopInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeExecuteThenPopInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @context.enable(CodePopInstruction)
      @i1 = CodeExecuteThenPopInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.enable(CodePopInstruction)
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
      
      it "should need CodePopInstruction to be enabled" do
        @context.disable(CodePopInstruction)
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        lambda{@i1.preconditions?}.should raise_error
        @context.enable(CodePopInstruction)
        lambda{@i1.preconditions?}.should_not raise_error
      end
      
    end
    
    describe "\#cleanup" do
      it "should push a new block based on the code from the top of the :code stack" do
        @context.stacks[:code].push(ValuePoint.new("code", "do foo_bar"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {\n  do foo_bar\n  do code_pop}"
        @context.stacks[:exec].peek.should be_a_kind_of(CodeblockPoint)
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref x}"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {\n  block {\n    ref x}\n  do code_pop}"
        @context.stacks[:exec].peek.should be_a_kind_of(CodeblockPoint)
      end
      
      it "push a block containing 'do code_pop' if the code point can't be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "whatever you say boss"))
        @i1.go
        @context.stacks[:exec].peek.listing.should == "block {\n  do code_pop}"
      end
    end
  end
end



describe CodeInstructionsInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeInstructionsInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeInstructionsInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "doesn't need any preconditions to be met, actually" do
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a block containing every active instruction" do
        # @context.disable_all_instructions
        @context.enable(CodeInstructionsInstruction)
        @context.enable(IntAddInstruction)
        @i1.go
        @context.stacks[:code].peek.value.should == "block { do code_instructions do int_add}"
        
        @context.enable(ExecPopInstruction)
        @i1.go
        @context.stacks[:code].peek.value.should == "block { do code_instructions do int_add do exec_pop}"
      end
    end
  end
end



describe CodeMemberQInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeMemberQInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeMemberQInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least two items on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should check to see if the second :code value is inside the [backbone of] the top item" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do int_multiply}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do something_else}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref x do int_multiply}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
      end
      
      it "should compare the two :code values for equality if the top one isn't a list" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
      end
      
      it "should return false if either item isn't parseable" do
        @context.stacks[:code].push(ValuePoint.new("code", "some crap"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "some other crap"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
      end
    end
  end
end



describe CodeContainsQInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeContainsQInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeContainsQInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least two items on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should check to see if the second :code value is any point of the top item" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do int_multiply}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do something_else}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref x do int_multiply}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "block { block{ref x} block {do int_multiply}}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
      end
      
      it "should compare the two :code values for equality if the top one isn't a list" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
      end
      
      it "should return false if either item isn't parseable" do
        @context.stacks[:code].push(ValuePoint.new("code", "some crap"))
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "do int_multiply"))
        @context.stacks[:code].push(ValuePoint.new("code", "some other crap"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
      end
    end
  end
end



describe CodeBackbonePointsInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeBackbonePointsInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeBackbonePointsInstruction.new(@context)
    end

    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should push an :int counting points in the backbone of the top :code item" do
        @context.stacks[:code].push(ValuePoint.new("code","block {ref x}"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 1
        
        @context.stacks[:code].push(ValuePoint.new("code",
          "block {ref a block {ref c ref d} block {ref ee}}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 3
      end
      
      it "should push a 0 if the top :code item is not a CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code","ref x"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 0
      end
      
      it "should push a 0 if the top :code item is an empty CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 0
      end
      
      it "should count non-parsing programs as having 0 points" do
        @context.stacks[:code].push(ValuePoint.new("code","I have no idea whatsoever"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 0
      end
    end
  end
end



describe CodeListInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeListInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeListInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least one item on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a new block containing the two :code items' code, in order" do
        @context.stacks[:code].push(ValuePoint.new("code", "do int_wha"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref huh"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do int_wha\n  ref huh}"
      end
      
      it "should work with footnotes correctly" do
        @context.stacks[:code].push(ValuePoint.new("code", "value «foo»\n«foo» bar"))
        @context.stacks[:code].push(ValuePoint.new("code",
          "block{value «foo» value «bun»}\n«foo» baz\n«bun» qux"))
        @i1.go
        @context.stacks[:code].peek.value.should include("\n«foo» bar\n«foo» baz\n«bun» qux")
      end
    end
  end
end


describe CodeConcatenateInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeConcatenateInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeConcatenateInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least two items on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a new concatenated block containing the two :code items' code, in order" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a do b}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do c}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a\n  do b\n  do c}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {block {do a}}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {block {do b}}"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  block {\n    do a}\n  block {\n    do b}}"
      end
      
      it "should append #2 to #1, if 2 is an atom and 1 a block" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a do b}"))
        @context.stacks[:code].push(ValuePoint.new("code", "do c"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a\n  do b\n  do c}"
      end
      
      it "should wrap #1 and #2 if #1 isn't a block" do
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code", "do b"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a\n  do b}"
      end
      
      it "should work with footnotes correctly" do
        @context.stacks[:code].push(ValuePoint.new("code", "value «a»\n«a» 1"))
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @i1.go
        @context.stacks[:code].peek.value.should ==
          "block {\n  value «a»\n  value «b»} \n«a» 1\n«b» 2"
      end
      
      it "should return an empty block if either arg is unparseable" do
        @context.stacks[:code].push(ValuePoint.new("code", "i got nuthin"))
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @context.stacks[:code].push(ValuePoint.new("code", "no idea"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
      end
    end
  end
end



describe CodePositionInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodePositionInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodePositionInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should need at least two items on the :code stack" do
        @context.clear_stacks
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "ref b"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref a"))
        lambda{@i1.preconditions?}.should_not raise_error
      end
    end
    
    describe "\#cleanup" do
      it "should push a the point in the top item which has the same #listing as the second item" do
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a do b}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 2
        
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {block {do a}}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 3
      end
      
      it "should return -1 if the string is not found" do
        @context.stacks[:code].push(ValuePoint.new("code", "do nothing"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do a do b}"))
        @i1.go
        @context.stacks[:int].peek.value.should == -1
      end
      
      it "should return 1 if they are the same" do
        @context.stacks[:code].push(ValuePoint.new("code", "do something"))
        @context.stacks[:code].push(ValuePoint.new("code", "do something"))
        @i1.go
        @context.stacks[:int].peek.value.should == 1
      end
      
      
      it "should return -1 if either arg is unparseable" do
        @context.stacks[:code].push(ValuePoint.new("code", "i got nuthin"))
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @i1.go
        @context.stacks[:int].peek.value.should == -1
        
        @context.stacks[:code].push(ValuePoint.new("code", "value «b»\n«b» 2"))
        @context.stacks[:code].push(ValuePoint.new("code", "no idea"))
        @i1.go
        @context.stacks[:int].peek.value.should == -1
      end
    end
  end
end



describe CodeDoRangeInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDoRangeInstruction.new(@context)
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


describe CodeDoCountInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDoCountInstruction.new(@context)
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



describe CodeParsesQInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeParsesQInstruction.new(@context)
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
      @i1 = CodeParsesQInstruction.new(@context)
      @context.reset
    end
    
    describe "\#preconditions?" do
      it "should check that there is at least one :code item" do
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset
      end
      
      it "should push a boolean 'false' if the top :code item can't be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code", "doint_add"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
      end
      
      it "should push a boolean 'true' value if the top :code item can be parsed" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {}"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "ref x"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "value «foo»\n«foo» bar"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
        
        @context.stacks[:code].push(ValuePoint.new("code", "do some_weird_stuff"))
        @i1.go
        @context.stacks[:bool].peek.value.should == true
      end
      
      it "should push false if the top item has no code (is only footnotes)" do
        @context.stacks[:code].push(ValuePoint.new("code", " \n«foo» bar\n«baz» qux"))
        @i1.go
        @context.stacks[:bool].peek.value.should == false
      end
    end
  end
end



describe CodeDiscrepancyInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeDiscrepancyInstruction.new(@context)
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
      @i1 = CodeDiscrepancyInstruction.new(@context)
      @context.reset
    end
    
    describe "\#preconditions?" do
      it "should check that there is at least two :code items" do
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset
      end
      
      it "should calculate the summed absolute difference in counts of all points in both programs" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref x"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref y"))
        @i1.go
        @context.stacks[:int].peek.value.should == 2
        
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y}"))
        @context.stacks[:code].push(ValuePoint.new("code", "ref y"))
        @i1.go
        @context.stacks[:int].peek.value.should == 1
        
        @context.stacks[:code].push(ValuePoint.new("code", "do x"))
        @context.stacks[:code].push(ValuePoint.new("code", "do x"))
        @i1.go
        @context.stacks[:int].peek.value.should == 0
      end
      
      it "should sum occurrences of different items, not just unique parts" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {do x do x do x do x}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {do y}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 7
      end
      
      it "should work as you would expect for NilPoint (unparseable) programs" do
        @context.stacks[:code].push(ValuePoint.new("code", "some weird crap"))
        @context.stacks[:code].push(ValuePoint.new("code", "nothing here either"))
        @i1.go
        @context.stacks[:int].peek.value.should == 0
        
        @context.stacks[:code].push(ValuePoint.new("code", "do real_program_stuff"))
        @context.stacks[:code].push(ValuePoint.new("code", "refx")) # unparseable
        @i1.go
        @context.stacks[:int].peek.value.should == 1
      end
      
      it "should not depend on typographic differences" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y value «int» \n«int» 91}"))
        @context.stacks[:code].push(ValuePoint.new("code",
          "block   {\n  ref  y \tvalue    «int» \n\n«int»  \t91}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 0
      end
    end
  end
end



describe CodeContainerInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeContainerInstruction.new(@context)
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
      @i1 = CodeContainerInstruction.new(@context)
      @context.reset
    end
    
    describe "\#preconditions?" do
      it "should check that there is at least two :code items" do
        lambda{@i1.preconditions?}.should raise_error
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @context.stacks[:code].push(ValuePoint.new("code", "foo"))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.reset
      end
      
      it "should copy the point from the 'haystack' that contains the 'needle' as a point in it" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref x"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref x}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  ref x}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code", "block { block {do a}}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a}"
        
        @context.stacks[:code].push(ValuePoint.new("code", "do a"))
        @context.stacks[:code].push(ValuePoint.new("code",
          "block { block { block {do b} do c} block {block { do a do b}}}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {\n  do a\n  do b}"
      end
      
      it "should return an empty block if it's not found" do
        @context.stacks[:code].push(ValuePoint.new("code", "ref x"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
      end
      
      # "but is not equal to"
      it "should return an empty block if the two code chunks are identical" do
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y}"))
        @context.stacks[:code].push(ValuePoint.new("code", "block {ref y}"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
      end
      
      it "should work as expected for unparseable code" do
        @context.stacks[:code].push(ValuePoint.new("code", "hee hee haw haw"))
        @context.stacks[:code].push(ValuePoint.new("code", "now is the time for all good men"))
        @i1.go
        @context.stacks[:code].peek.value.should == "block {}"
      end
    end
  end
end
