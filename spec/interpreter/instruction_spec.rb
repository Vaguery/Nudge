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
  
  describe "#blueprint_parts" do
    it "should return an Array containing (1) InstructionPoint#tidy and (2) an empty string" do
      myIP = InstructionPoint.new("bah_8")
      myIP.blueprint_parts.should == [myIP.tidy,""]
    end
  end
  
  describe "#blueprint" do
    it "should work just like #tidy" do
      InstructionPoint.new("low_ball").blueprint.should == "do low_ball"
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
      
      it "should raise an InstructionNotFoundError if the class doesn't exist" do
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
    
    it "should push an :error ValuePoint if the instruction is not active" do
      context = Interpreter.new
      context.disable(IntAddInstruction)
      myI = InstructionPoint.new("int_add").go(context)
      context.stacks[:error].depth.should == 1
      context.stacks[:error].peek.raw.should ==
        "IntAddInstruction is not an active instruction in this context"
    end
    
    it "should push an :error ValuePoint if the instruction doesn't exist" do
      context = Interpreter.new
      myI = InstructionPoint.new("i_will_fail").go(context)
      context.stacks[:error].depth.should == 1
      context.stacks[:error].peek.raw.should include("IWillFailInstruction")
    end
    
  end
  
  
  describe "#needs" do
    it "should check the stack depth" do
      context = Interpreter.new
      2.times {context.stacks[:foo].push ValuePoint.new("foo")}
      dummy = Instruction.new(context)
      context.stacks[:foo].should_receive(:depth).and_return(2)
      dummy.needs(:foo)
    end
    
    it "should check there's at least one thing on a stack, if the number isn't specified" do
      context = Interpreter.new
      2.times {context.stacks[:foo].push ValuePoint.new("foo")}
      dummy = Instruction.new(context)
      lambda{dummy.needs :foo}.should_not raise_error
      lambda{dummy.needs :bar}.should raise_error
    end
    
    it "should check there's enough things on a stack, if the number is specified" do
      context = Interpreter.new
      2.times {context.stacks[:foo].push ValuePoint.new("foo")}
      dummy = Instruction.new(context)
      lambda{dummy.needs :foo, 2}.should_not raise_error
      lambda{dummy.needs :foo, 9}.should raise_error
    end
    
    it "should return 'true' if it works" do
      context = Interpreter.new
      1.times {context.stacks[:foo].push ValuePoint.new("foo")}
      dummy = Instruction.new(context)
      dummy.needs(:foo).should == true
      lambda{dummy.needs :foo, 2}.should raise_error
    end
    
    it "should alternately accept an instruction class name (in constant form)" do
      context = Interpreter.new
      context.enable(IntAddInstruction)
      dummy = Instruction.new(context)
      lambda{dummy.needs(IntAddInstruction)}.should_not raise_error
    end
    
    it "should return true if that instruction class constant is an active instruction" do
      context = Interpreter.new
      context.enable(IntAddInstruction)
      dummy = Instruction.new(context)
      dummy.needs(IntAddInstruction).should == true
    end
    
    it "should raise an exception if the class is not active" do
      context = Interpreter.new
      context.disable(IntAddInstruction)
      dummy = Instruction.new(context)
      lambda{dummy.needs(IntAddInstruction)}.should raise_error(Instruction::MissingInstructionError)
    end
    
    it "should raise an ActiveSupport exception if the class is not defined" do
      context = Interpreter.new
      lambda{Instruction.new(context).needs(FooBazInstruction)}.should raise_error(ArgumentError,
        "Anonymous modules have no name to be referenced by")
    end
  end
end