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