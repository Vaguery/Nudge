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
      @name1 = ReferencePoint.new("xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :int" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:int].push(ValuePoint.new("int", 123))
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
        @context.stacks[:int].push(ValuePoint.new("int", 123))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:int].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 123
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", ValuePoint.new("bool", false))
        @context.names["xyz"].value.should == false
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:int].push(ValuePoint.new("int", 123))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:int].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 123
      end
      
      it "should not re-bind a name that is a variable, though" do
        @context.bind_variable("xyz", ValuePoint.new("bool", false))
        @context.stacks[:int].push(ValuePoint.new("int", 456))
        @context.stacks[:name].push(ReferencePoint.new("xyz"))
        lambda{@i1.go}.should raise_error
      end
      
      it "should raise an exception if it's binding the name to anything but a ValuePoint" do
        @context.stacks[:int].push(9912) #the actual number
        @context.stacks[:name].push(@name1)
        lambda{@i1.go}.should raise_error
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
      @name1 = ReferencePoint.new("xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :bool" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:bool].push(ValuePoint.new("bool", false))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :bool to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:bool].push(ValuePoint.new("bool", false))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:bool].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == false
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", ValuePoint.new("float", 3.3))
        @context.names["xyz"].value.should == 3.3
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:bool].push(ValuePoint.new("bool", false))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:bool].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == false
      end
      
      it "should not re-bind a name that is a variable, though" do
        @context.bind_variable("xyz", ValuePoint.new("bool", false))
        @context.stacks[:bool].push(ValuePoint.new("bool", 456))
        @context.stacks[:name].push(ReferencePoint.new("xyz"))
        lambda{@i1.go}.should raise_error
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
      @name1 = ReferencePoint.new("xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :float" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:float].push(ValuePoint.new("float", -11.11))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :float to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:float].push(ValuePoint.new("float", -11.11))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:float].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should be_close(-11.11,0.00001)
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", ValuePoint.new("int", 999))
        @context.names["xyz"].value.should == 999
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:float].push(ValuePoint.new("float", -11.11))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:float].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == -11.11
      end
      
      it "should not re-bind a name that is a variable, though" do
        @context.bind_variable("xyz", ValuePoint.new("bool", false))
        @context.stacks[:float].push(ValuePoint.new("float", 4.56))
        @context.stacks[:name].push(ReferencePoint.new("xyz"))
        lambda{@i1.go}.should raise_error
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
      @name1 = ReferencePoint.new("xyz")
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :name and one :exec item" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:exec].push(CodeblockPoint.new([]))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        @context.reset_names
      end
      
      it "should bind the top :exec item to the top :name" do
        @context.stacks[:name].push(@name1)
        @context.stacks[:exec].push(CodeblockPoint.new([]))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].listing.should == "block {}"
        @context.names["xyz"].should be_a_kind_of(CodeblockPoint)
        
      end
      
      it "should overwrite the binding if it already exists" do
        @context.bind_name("xyz", ValuePoint.new("int", 999))
        @context.names["xyz"].value.should == 999
        
        @context.stacks[:name].push(@name1)
        @context.stacks[:exec].push(ValuePoint.new("int", 22))
        @i1.go
        @context.stacks[:name].depth.should == 0
        @context.stacks[:exec].depth.should == 0
        @context.names.length.should_not == 0        
        @context.names["xyz"].value.should == 22
      end
      
      it "should not re-bind a name that is a variable, though" do
        @context.bind_variable("xyz", ValuePoint.new("bool", false))
        @context.stacks[:exec].push(ValuePoint.new("int", 456))
        @context.stacks[:name].push(ReferencePoint.new("xyz"))
        lambda{@i1.go}.should raise_error
      end
    end
  end
end