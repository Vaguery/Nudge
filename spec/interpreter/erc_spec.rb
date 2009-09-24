require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "erc" do
  
  describe "initialization" do
    it "should take a type name with no default value" do
      myE = Erc.new("int")
      myE.type.should == :int
      lambda {Erc.new()}.should raise_error(ArgumentError)
    end
    
    it "should take an optional value, defaulting to nil" do
      myE = Erc.new("int",12)
      myE.value.should == 12
    end
    
    it "should be created with a default randomizer that does nothing"
    
    it "should allow you to set a new randomizer"
    
    it "should be a kind of program point" do
      myE = Erc.new("int")
      myE.should be_a_kind_of(ProgramPoint)
    end
  end
    
  describe "randomization" do
    it "should demand the randomizer is a Proc object that returns a value"
    
    it "should invoke the attribute's randomizer code when Erc#randomize is called"
    
    it "should be possible to temporarily override the randomize code with a block"
  end
  
  describe "converting to a literal" do
    it "should allow you to cast it to a Literal with the same values" do
      myE = Erc.new("int", 4)
      asL = myE.to_literal
      asL.type.should == :int
      asL.value.should == 4
    end
    it "should automatically set the value when converting, if it's not set"
  end
  
  describe "#go" do
    before(:each) do
      @ii = Interpreter.new()
      Stack.cleanup
      Stack.stacks[:int] = Stack.new(:int)
      @ii.reset("erc int,999")
    end
    
    it "should pop the exec stack when an Erc is interpreted" do
      oldExec = Stack.stacks[:exec].depth
      @ii.step
      Stack.stacks[:exec].depth.should == (oldExec-1)
    end
    
    it "should initialize the right stack for the type of the Erc if it doesn't exist" do
      Stack.stacks.delete(:int)
      @ii.step
      Stack.stacks.should include(:int)
    end
    
    it "should use the existing stack if it does exist" do
      @ii.step
      Stack.stacks[:int].depth.should == 1
    end

    it "should push the value onto the right stack" do
      Stack.stacks[:exec].push(Erc.new("int",3))
      Stack.stacks[:exec].push(Erc.new("float",2.2))
      Stack.stacks[:exec].push(Erc.new("bool",false))
      
      3.times {@ii.step}
      Stack.stacks.should include(:int)
      Stack.stacks.should include(:float)
      Stack.stacks.should include(:bool)
    end
    
    it "should check for CODE size limits"
  end
  
  describe "#tidy" do
    it "should print 'erc type, value' for Erc#tidy" do
      myE = Erc.new("float", -99.121001)
      myE.tidy.should == "erc float, -99.121001"
    end
  end
  
end