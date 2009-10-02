require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Channel class attributes" do
  describe "variables table" do
    it "should be an empty hash initially" do
      Channel.variables.should == {}
    end
    
    it "should create a new entry when #bind_variable is called" do
      Channel.bind_variable("x",LiteralPoint.new(:int,88))
      Channel.variables["x"].should be_a_kind_of(LiteralPoint)
      Channel.variables["x"].type.should == :int
      Channel.variables["x"].value.should == 88
    end
    
    it "should raise an exception if the bound value is anything but a LiteralPoint" do
      lambda {Channel.bind_variable("x", 88)}.should raise_error(ArgumentError)
      lambda {Channel.bind_variable("x", [1,2])}.should raise_error(ArgumentError)
      lambda {Channel.bind_variable("x", nil)}.should raise_error(ArgumentError)
    end
    
    it "should be resettable" do
      Channel.bind_variable("x",LiteralPoint.new(:int,88))
      Channel.reset_variables
      Channel.variables.should_not include("x")
    end
  end
  
  describe "names table" do
    it "should be an empty hash initially" do
      Channel.names.should == {}
    end
    
    it "should create a new entry when #bind_name is called" do
      Channel.bind_name("x",LiteralPoint.new(:bool,false))
      Channel.names["x"].should be_a_kind_of(LiteralPoint)
      Channel.names["x"].type.should == :bool
      Channel.names["x"].value.should == false
    end
    
    it "should raise an exception if the bound value is anything but a LiteralPoint" do
      lambda {Channel.bind_name("x", 88)}.should raise_error(ArgumentError)
      lambda {Channel.bind_name("x", [1,2])}.should raise_error(ArgumentError)
      lambda {Channel.bind_name("x", nil)}.should raise_error(ArgumentError)
    end
    
    it "should be resettable" do
      Channel.bind_name("x",LiteralPoint.new(:int,88))
      Channel.reset_names
      Channel.names.should_not include("x")
    end
    
  end
end

describe "Channel Point" do
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
      @ii.reset("block{\nchannel x\nchannel y\nchannel z}")
      Channel.bind_variable("x", LiteralPoint.new("float", 1.1))
      Channel.bind_name("y", LiteralPoint.new("int", 99999))
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
  end
  
  describe "#tidy" do
    it "should return 'channel x' when the name is 'x'" do
      myC = Channel.new("x")
      myC.tidy.should == "channel x"
    end
  end
  
  describe "randomize" do
    it "should set the Channel's name to a randomly selected channel or name key" do
      Channel.reset_variables
      Channel.reset_names
      myC = Channel.new("a")
      Channel.bind_name("y",LiteralPoint.new("bool", false))
      myC.randomize
      myC.name.should == "y"
      Channel.reset_names
      Channel.bind_variable("z",LiteralPoint.new("bool", false))
      myC.randomize
      myC.name.should == "z"
    end
  end
  
end