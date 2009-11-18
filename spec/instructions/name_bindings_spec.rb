require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe IntDefineInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = IntDefineInstruction.new(@context)
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
      @i1 = IntDefineInstruction.new(@context)
      @context.clear_stacks
      @name1 = LiteralPoint.new("name", "xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :int" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:int].push(LiteralPoint.new("int", 123))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :int to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:int].push(LiteralPoint.new("int", 123))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:int].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 123
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", LiteralPoint.new("bool", false))
        @context.names["xyz"].value.should == false
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:int].push(LiteralPoint.new("int", 123))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:int].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 123
      end
    end
  end
end


describe BoolDefineInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = BoolDefineInstruction.new(@context)
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
      @i1 = BoolDefineInstruction.new(@context)
      @context.clear_stacks
      @name1 = LiteralPoint.new("name", "xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :int" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:bool].push(LiteralPoint.new("bool", false))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :int to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:bool].push(LiteralPoint.new("bool", false))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:bool].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == false
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", LiteralPoint.new("float", 3.3))
        @context.names["xyz"].value.should == 3.3
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:bool].push(LiteralPoint.new("bool", false))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:bool].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == false
      end
    end
  end
end


describe FloatDefineInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = FloatDefineInstruction.new(@context)
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
      @i1 = FloatDefineInstruction.new(@context)
      @context.clear_stacks
      @name1 = LiteralPoint.new("name", "xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :int" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:float].push(LiteralPoint.new("float", -11.11))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :int to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:float].push(LiteralPoint.new("float", -11.11))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:float].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should be_close(-11.11,0.00001)
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", LiteralPoint.new("int", 999))
        @context.names["xyz"].value.should == 999
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:float].push(LiteralPoint.new("float", -11.11))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:float].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == -11.11
      end
    end
  end
end


describe ExecDefineInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecDefineInstruction.new(@context)
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
      @i1 = ExecDefineInstruction.new(@context)
      @context.clear_stacks
      @name1 = LiteralPoint.new("name", "xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :int" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:exec].push(LiteralPoint.new("int", 22))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :int to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:exec].push(LiteralPoint.new("int", 22))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 22
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", LiteralPoint.new("int", 999))
        @context.names["xyz"].value.should == 999
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:exec].push(LiteralPoint.new("int", 22))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 22
      end
    end
  end
end