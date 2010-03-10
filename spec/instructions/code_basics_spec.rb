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
      it "should push a :bool indicating whether the :code value is 'block {}' or not" do
        @context.stacks[:code].push(ValuePoint.new("code","ref x"))
        @i1.go
        @context.stacks[:bool].depth.should == 1
        @context.stacks[:bool].peek.value.should == false
        
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.go
        @context.stacks[:bool].depth.should == 2
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
      it "should push a :bool indicating whether the :code value is 'block {}' or not" do
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
        lambda{@i1.go}.should raise_error
      end
      
      it "should check for unparseable code values"
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

