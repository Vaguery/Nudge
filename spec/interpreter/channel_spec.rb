require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Channel class attributes" do
  describe "variables table" do
    it "should be an empty hash initially" do
      Channel.variables.should == {}
    end
    
    it "should create a new entry when #bind_variable is called" do
      Channel.bind_variable("x",Literal.new(:int,88))
      Channel.variables["x"].should be_a_kind_of(Literal)
      Channel.variables["x"].type.should == :int
      Channel.variables["x"].value.should == 88
    end
  end
  
  describe "names table" do
    it "should be an empty hash initially" do
      Channel.names.should == {}
    end
    
    it "should create a new entry when #bind_name is called" do
      Channel.bind_name("x",Literal.new(:bool,false))
      Channel.names["x"].should be_a_kind_of(Literal)
      Channel.names["x"].type.should == :bool
      Channel.names["x"].value.should == false
    end
    
  end
end

describe "channel" do
  it "should be a kind of program point" do
    myC = Channel.new("x")
    myC.should be_a_kind_of(ProgramPoint)
  end
  
  it "should have a name parameter with no default" do
    myC = Channel.new("x")
    myC.should be_a_kind_of(Channel)
    myC.name.should == "x"
    lambda {Channel.new()}.should raise_error(ArgumentError)
  end
  
  describe "#go" do
    before(:each) do
      @ii = Interpreter.new()
      Stack.cleanup
      @ii.load("block{\nchannel x\nchannel y\nchannel z}")
      Channel.bind_variable("x", Literal.new("float", 1.1))
      Channel.bind_name("y", Literal.new("int", 99999))
      #Channel z is unbound
    end
    
    it "should pop the exec stack when the program_point Channel is interpreted" do
      Stack.stacks[:exec].depth.should == 1
      @ii.step
      Stack.stacks[:exec].depth.should == 3
      @ii.step
      Stack.stacks[:exec].depth.should == 3
      Stack.stacks[:exec].peek.value.should == 1.1
      2.times {@ii.step}
      Stack.stacks[:exec].depth.should == 2
      Stack.stacks[:exec].peek.value.should == 99999
    end
    
    it "should push the Channel object onto the :name stack if it's not bound" do
      6.times {@ii.step}
      Stack.stacks[:name].depth.should == 1
      Stack.stacks[:name].peek.name.should == "z"
    end

    it "should push the value onto the right stack" do
      3.times {@ii.step}
      Stack.stacks[:float].peek.value.should == 1.1
      2.times {@ii.step}
      Stack.stacks[:int].peek.value.should == 99999
      @ii.step
      Stack.stacks[:name].peek.name.should == "z"
    end

    it "should check for CODE size limits"
  end
  
end