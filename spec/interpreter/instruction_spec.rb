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
  
  [["int_add","IntAddInstruction"],["bool_greaterthan?", "BoolGreaterthan?Instruction"]].each do |inp|
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
        IntAddInstruction = true
        myI = InstructionPoint.new("int_add")
        myI.classLookup.should == IntAddInstruction
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
    
    it "should handle an InstructionNotFoundError if the classLookup raised it" do
      pending "not really the end behavior; it should leave a hook for counting at least"
      myI = InstructionPoint.new("foo_baz")
      lambda{myI.go}.should_not raise_error(InstructionPoint::InstructionNotFoundError)
    end
    
    #   create the className 
    #   determine if it exists or not
    #   if it does, DO THAT
    #     check for preconditions (stacks have stuff)
    #   if the params exist, pop them
    #   calculate the result as a Literal
    #   push! it
    #   otherwise raise an exception of some sort
    
  end
end

describe "Instruction Singletons" do
  it "should description" do
    
  end
end