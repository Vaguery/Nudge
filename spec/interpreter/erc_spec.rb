require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "erc" do
  describe "initialization" do
    it "should take a type name with no default value" do
      myE = Erc.new("int",11)
      myE.type.should == :int
      lambda {Erc.new()}.should raise_error(ArgumentError)
    end
    
    it "should take an obligatory value param, with no default" do # this is a change of the original specs
      myE = Erc.new("int",-99999)
      myE.value.should == -99999
      lambda{Erc.new("int")}.should raise_error(ArgumentError)
    end
    
    it "should set the value as with a LiteralPoint, if it's given" do
      myE = Erc.new("bool",false)
      myE.value.should == false
    end
    
    it "should be a kind of program point" do
      myE = Erc.new("bool", true)
      myE.should be_a_kind_of(ProgramPoint)
    end
  end
  
  describe "converting to a literal" do
    it "should allow you to cast it to a Literal with the same values" do
      myE = Erc.new("int", 4)
      asL = myE.to_literal
      asL.type.should == :int
      asL.value.should == 4
    end
  end
  
  describe "#go" do
    before(:each) do
      @ii = Interpreter.new()
      @ii.clear_stacks
      @ii.stacks[:int] = Stack.new(:int)
      @ii.reset("sample int (999)")
    end
    
    it "should pop the exec stack when an Erc is interpreted" do
      oldExec = @ii.stacks[:exec].depth
      @ii.step
      @ii.stacks[:exec].depth.should == (oldExec-1)
    end
    
    it "should initialize the right stack for the type of the Erc if it doesn't exist" do
      @ii.stacks.delete(:int)
      @ii.step
      @ii.stacks.should include(:int)
    end
    
    it "should use the existing stack if it does exist" do
      @ii.step
      @ii.stacks[:int].depth.should == 1
    end

    it "should push the value onto the right stack" do
      @ii.stacks[:exec].push(Erc.new("int",3))
      @ii.stacks[:exec].push(Erc.new("float",2.2))
      @ii.stacks[:exec].push(Erc.new("bool",false))
      
      3.times {@ii.step}
      @ii.stacks.should include(:int)
      @ii.stacks.should include(:float)
      @ii.stacks.should include(:bool)
    end
  end
  
  describe "#tidy" do
    it "should print 'sample type, value' for Erc#tidy" do
      myE = Erc.new("float", -99.121001)
      myE.tidy.should == "sample float (-99.121001)"
    end
  end
  
  describe "randomize" do
    before(:each) do
      @ii = Interpreter.new()
      @ii.enable_all_types
    end
    
    it "should return one of the active types (not one of the defined types!)" do
      myErc = LiteralPoint.new("float", -77.89)
      @ii.disable_all_types
      @ii.enable(IntType)
      myErc.randomize(@ii)
      myErc.type.should == :int
    end
  end
  
  describe "#any" do
    before(:each) do
      @ii = Interpreter.new()
      @ii.enable_all_types
    end
    
    it "should return a new instance, invoking #randomize" do
      rE = Erc.any(@ii)
      rE.should be_a_kind_of(Erc)
      @ii.disable_all_types
      @ii.enable(BoolType)
      rE = Erc.any(@ii)
      rE.type.should == :bool
    end
  end
  
  describe "#resample" do
    it "should change the value only of the calling Erc instance, not its type" do
      rE = Erc.new("int", 99)
      rE.should be_a_kind_of(Erc)
      IntType.should_receive(:any_value).and_return(2)
      rE.value.should == 99
      rE.resample
      rE.value.should == 2
      
      rE = Erc.new("bool", false)
      rE.should be_a_kind_of(Erc)
      BoolType.should_receive(:any_value).and_return(true)
      rE.value.should == false
      rE.resample
      rE.value.should == true
    end      
  end
end