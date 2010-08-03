# encoding: UTF-8
require File.expand_path("../nudge", File.dirname(__FILE__))

describe "NudgeInstruction" do
  describe ".execute (instruction_name: Symbol, executable: NudgeExecutable)" do
    it "calls #execute on a new instance of the class specified by instruction_name" do
      exe = NudgeExecutable.new("do int_depth")
      instruction = IntDepth.new(exe)
      
      IntDepth.should_receive(:new).and_return(instruction)
      instruction.should_receive(:execute)
      
      NudgeInstruction.execute(:int_depth, exe)
    end
    
    it "raises UnknownInstruction if instruction_name is not recognized" do
      exe = NudgeExecutable.new("do no_such_instruction")
      lambda { NudgeInstruction.execute(:no_such_instruction, exe) }.should raise_error NudgeError::UnknownInstruction,
        "no_such_instruction not recognized"
    end
    
    it "raises MissingArguments if the stacks do not contain the necessary arguments" do
      exe = NudgeExecutable.new("do int_add")
      lambda { NudgeInstruction.execute(:int_add, exe) }.should raise_error NudgeError::MissingArguments,
        "int_add missing arguments"
    end
  end
  
  describe ".new (executable: NudgeExecutable)" do
    it "sets @executable" do
      exe = NudgeExecutable.new("do int_depth")
      instruction = NudgeInstruction.new(exe)
      
      instruction.instance_variable_get(:@executable).should == exe
    end
    
    it "sets @arguments to a new hash" do
      exe = NudgeExecutable.new("do int_depth")
      instruction = NudgeInstruction.new(exe)
      
      instruction.instance_variable_get(:@arguments).should be_a Hash
    end
  end
  
  describe "#execute" do
    it "calls #process on the instruction" do
      exe = NudgeExecutable.new("do int_depth")
      instruction = IntDepth.new(exe)
      
      instruction.should_receive(:process)
      
      instruction.execute
    end
  end
  
  describe "#put" do
    it "" do
      pending
    end
  end
end

describe "instruction_subclass" do
  describe ".get (n: Integer, value_type: Symbol)" do
    it "" do
      pending
    end
  end
end
