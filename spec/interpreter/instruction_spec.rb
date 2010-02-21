require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

class MyThingInstruction < Instruction
end

class PirateTalkInstruction < Instruction
  def go
  end
end

describe "InstructionPoint" do
  it "should have a name parameter, with no default" do
    myI = InstructionPoint.new("foo_bar")
    myI.name.should == "foo_bar"
    lambda {InstructionPoint.new()}.should raise_error(ArgumentError)
  end
  
  it "should have a symbol as a name" do
    myI = InstructionPoint.new("foo_bar")
    myI.name.should be_a_kind_of(String)
  end
  
  it "should be a kind of program point" do
    myL = InstructionPoint.new("int_thing")
    myL.should be_a_kind_of(ProgramPoint)
  end
  
  describe "#tidy" do
    it "should return 'do x' when the name is 'x'" do
      myI = InstructionPoint.new("x")
      myI.tidy.should == "do x"
    end
  end
  
  describe "#listing_parts" do
    it "should return an Array containing (1) InstructionPoint#tidy and (2) an empty string" do
      myIP = InstructionPoint.new("bah_8")
      myIP.listing_parts.should == [myIP.tidy,""]
    end
  end
  
  
  [["plant_water","PlantWaterInstruction"],["opinion_greaterthan?", "OpinionGreaterthan?Instruction"]].each do |inp|
    it "should know the appropriate class name for the Instruction singleton for #{inp}" do
      pointName = inp[0]
      cName = inp[1]
      myI = InstructionPoint.new(pointName)
      myI.className.should == cName
    end
  end
  
  
  describe "#go" do
    describe "class lookup" do
      it "should find the appropriate class (by name), if it exists, in an Interpreter context" do
        myI = InstructionPoint.new("my_thing")
        myI.classLookup.should == MyThingInstruction
      end

      it "should raise a InstructionNotFoundError if the class doesn't exist" do
        myI = InstructionPoint.new("foo_baz")
        lambda{myI.classLookup}.should raise_error(InstructionPoint::InstructionNotFoundError)
      end
    end
    
    it "should delegate #go to the appropriate Instruction Class" do
      context = Interpreter.new
      context.enable(IntAddInstruction)
      context.instructions_library[IntAddInstruction].should_receive(:go)
      myI = InstructionPoint.new("int_add").go(context)
    end
  end
  
  describe "randomize" do
    before(:each) do
      @context = Interpreter.new
      @context.enable_all_instructions
    end
    
    it "should return one of the active instructions" do
      myInstrP = InstructionPoint.new("float_multiply")
      @context.disable_all_instructions
      @context.enable(IntAddInstruction)
      myInstrP.randomize(@context)
      myInstrP.name.should == "int_add"
    end
  end
  
  describe "any" do
    before(:each) do
      @context = Interpreter.new
      @context.enable_all_instructions
    end
    
    it "should return a new instance of an instruction, invoking randomize" do
      someI = InstructionPoint.any(@context)
      someI.should be_a_kind_of(InstructionPoint)
      @context.disable_all_instructions
      @context.enable(FloatSubtractInstruction)
      someI = InstructionPoint.any(@context)
      someI.name.should == "float_subtract"
    end
  end
end