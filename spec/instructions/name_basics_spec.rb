require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe NameRandomBoundInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameRandomBoundInstruction.new(@context)
  end
  
  it "should have a context upon creation" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = NameRandomBoundInstruction.new(@context)
      @bar = LiteralPoint.new("int", 99)
      @context.reset_names
      @context.reset_variables
    end
    
    describe "\#preconditions?" do
      it "should check that there are any bound variables or names" do
        @i1.preconditions?.should == false
        
        @context.bind_variable("d", @bar)
        @i1.preconditions?.should == true
        
        @context.reset_variables
        @context.bind_name("r", @bar)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should push a random sample of the bound references in @context" do
        @context.bind_variable("d", @bar)
        @i1.go
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.should be_a_kind_of(ChannelPoint)
        @context.stacks[:exec].peek.value.should == "d"
        
        @context.reset_variables
        @context.bind_name("e", @bar)
        @i1.go
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].peek.should be_a_kind_of(ChannelPoint)
        @context.stacks[:exec].peek.value.should == "e"
        
        @context.reset_names
        @i1.go # nothing should happen
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].peek.should be_a_kind_of(ChannelPoint)
        @context.stacks[:exec].peek.value.should == "e"
      end
    end
  end
end


describe NameNextInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameNextInstruction.new(@context)
  end
  
  it "should have a context upon creation" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = NameNextInstruction.new(@context)
      @context.reset
    end
    
    describe "\#preconditions?" do
      it "should always be ready to go" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should push a new ChannelPoint onto :exec, with an incremented value" do
        @context.last_name.should == "refAAAAA"
        @i1.go
        @context.last_name.should == "refAAAAB"
        @context.stacks[:exec].depth.should == 1
        @i1.go
        @context.last_name.should == "refAAAAC"
        @context.stacks[:exec].peek.value.should == "refAAAAC"
      end
    end
  end
end


describe NameDisableLookupInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = NameDisableLookupInstruction.new(@context)
  end
  
  it "should have a context upon creation" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = NameDisableLookupInstruction.new(@context)
      @bar = LiteralPoint.new("int", 99)
      @context.bind_name("zzzz", @bar)
    end
    
    describe "\#preconditions?" do
      it "should always be ready to go" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should switch off channel lookup until one NAME is encountered" do
        3.times {@context.stacks[:exec].push(ChannelPoint.new("zzzz"))}
        
        @context.evaluate_channels.should == true
        2.times {@context.step} # looks up 'zzzz', pushes to :exec; pushes to :int
        @context.stacks[:int].peek.value.should == 99
        
        @i1.go
        @context.evaluate_channels.should == false
        
        @context.step # doesn't look it up, pushes ChannelPoint to :name
        @context.stacks[:name].peek.value.should == "zzzz"
        @context.evaluate_channels.should == true
        2.times {@context.step} # looks up 'zzzz' again, pushes to :exec; pushes to :int
        @context.stacks[:int].depth.should == 2
      end
    end
  end
end
