#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge


describe NudgeProgram do
  describe "#random" do
    it "should return a new random-code program, given no params" do
      lambda{NudgeProgram.random}.should_not raise_error
      NudgeProgram.random.should be_a_kind_of(NudgeProgram)
    end
    
    it "should use the 'global' defaults as needed" do
      NudgeProgram.random.points.should == 20
      Instruction.should_receive(:all_instructions).at_least(1).times.and_return([IntAddInstruction])
      NudgeType.should_receive(:all_types).at_least(1).times.and_return([IntType])
      NudgeProgram.random
    end
    
    it "should accept an overridden_parameters Hash" do
      NudgeProgram.random(target_size_in_points:30).points.should == 30
      NudgeProgram.random(probabilities: {b:10, r:0, v:0, i:0}).blueprint.
        scan("block").length.should == 20 # there should be 20 occurrences of 'block' only!
      NudgeProgram.random(reference_names:["x"], probabilities: {b:0, r:10, v:0, i:0}).blueprint.
        scan("ref x").length.should == 19 # there should be 19 occurrences of 'ref x' in a wrapper
      NudgeProgram.random(type_names:["foo"], probabilities: {b:0, r:0, v:10, i:0}).blueprint.
        scan("foo").length.should == 38 # there should be 19 occurrences of 'value «foo»', plus fn's
      NudgeProgram.random(instruction_names:["bool_xor"], probabilities: {b:0, r:0, v:0, i:10}).blueprint.
        scan("bool_xor").length.should == 19 # there should be 19 occurrences of 'do bool_xor'
    end
  end
end