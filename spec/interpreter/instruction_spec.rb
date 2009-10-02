require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

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
  
  it "should have a requirements attribute, which defaults to an empty hash" do
    myI = InstructionPoint.new("foo_bar")
    myI.requirements.should == {}
  end
  
  it "should have an effects attribute, which defaults to an empty hash" do
    myI = InstructionPoint.new("foo_bar")
    myI.effects.should == {}
  end
  
  describe "#tidy" do
    it "should return 'instr x' when the name is 'x'" do
      myI = InstructionPoint.new("x")
      myI.tidy.should == "instr x"
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
      it "should find the appropriate class (by name) if it exists" do
        MyThingInstruction = true
        myI = InstructionPoint.new("my_thing")
        myI.classLookup.should == MyThingInstruction
      end

      it "should raise a InstructionNotFoundError if the class doesn't exist" do
        myI = InstructionPoint.new("foo_baz")
        lambda{myI.classLookup}.should raise_error(InstructionPoint::InstructionNotFoundError)
      end
    end
    
    it "should delegate #go to the appropriate Instruction Class" do
      class PirateTalkInstruction
        def self.instance
          @singleton ||= self.new
        end
        def go
        end
      end
      singleton = PirateTalkInstruction.instance
      singleton.should_receive(:go)
      myI = InstructionPoint.new("pirate_talk").go
    end
  end
  
  describe "randomize" do
    before(:each) do
      Instruction.all_instructions.each {|t| t.activate}
    end
    after(:each) do
      Instruction.all_instructions.each {|t| t.activate}
    end
    
    
    it "should return one of the active instructions" do
      myInstrP = InstructionPoint.new("float_multiply")
      
      Instruction.all_instructions.each {|t| t.deactivate}
      
      Instruction.active_instructions.length.should == 0
      IntAddInstruction.activate
      myInstrP.randomize
      myInstrP.name.should == "int_add"
    end
  end
  
end