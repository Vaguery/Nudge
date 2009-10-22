require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Code Type" do
  it "should be a Singleton" do
    CodeType.instance.should be_a_kind_of(Singleton)
  end
  
  
  
  it "should return the result of self.randomize when it receives an #any_value call" do
    CodeType.should_receive(:random_value).and_return("hi there!")
    CodeType.any_value.should == "hi there!"
  end
  
  
  
  describe "#random_skeleton" do    
    it "should accept params for points and branchiness" do
      lambda{CodeType.random_skeleton(3,1)}.should_not raise_error
    end
    
    it "should return a string filled with asterisks and 'block{}'" do
      CodeType.random_skeleton(3,0).should == "block {**}"
      CodeType.random_skeleton(3,1).should == "block {**}"      
      CodeType.random_skeleton(1,1).should == "block {}"
      CodeType.random_skeleton(2,2).should == "block { block {}}"
      CodeType.random_skeleton(20,3).count("}").should == 3
    end
    
    it "should limit range-check the blocks parameter" do
      CodeType.random_skeleton(1,40).should == "block {}"
      CodeType.random_skeleton(4,20).count("}").should == 4
      CodeType.random_skeleton(4,-20).count("}").should == 1
      CodeType.random_skeleton(1,-20).should == "*"
    end
  end
  
  
  
  describe "any_type" do
    it "should return a single sample from the list of items passed in (no implied validation)" do
      CodeType.any_type([1]).should == 1
    end
    
    it "should default to the list of ActiveTypes" do
      NudgeType.all_off
      IntType.activate
      CodeType.any_type.should == IntType
    end
    
    it "should raise an error if the list of active_types is empty and none is passed in" do
      NudgeType.all_off
      lambda{CodeType.any_type}.should raise_error(ArgumentError)
    end
    
    it "should raise an error if the list of types passed in is empty" do
      lambda{CodeType.any_type([])}.should raise_error(ArgumentError)
    end
  end
  
  
  
  describe "any_instruction" do
    it "should return a single sample from the list of items passed in (no implied validation)" do
      CodeType.any_instruction([1]).should == 1
    end
    
    it "should default to the list of active instructions" do
      Instruction.all_off
      IntAddInstruction.activate
      CodeType.any_instruction.should == IntAddInstruction
    end
    
    it "should raise an error if the list of active instructions is empty and none is passed in" do
      Instruction.all_off
      lambda{CodeType.any_instruction}.should raise_error(ArgumentError)
    end
    
    it "should raise an error if the list of instructions passed in is empty" do
      lambda{CodeType.any_instruction([])}.should raise_error(ArgumentError)
    end
  end
  
  
  
  describe "any_reference" do
    it "should return a single sample from the list of items passed in (no implied validation)" do
      CodeType.any_reference([1]).should == 1
    end
    
    it "should default to the list of active references" do
      Channel.reset_variables
      Channel.bind_variable("x",LiteralPoint.new(:int,12))
      CodeType.any_reference.should == "x"
    end
    
    it "should raise an error if the list of active references is empty and none is passed in" do
      Channel.reset_variables
      Channel.reset_names
      lambda{CodeType.any_reference}.should raise_error(ArgumentError)
    end
    
    it "should raise an error if the list of references passed in is empty" do
      lambda{CodeType.any_reference([])}.should raise_error(ArgumentError)
    end
  end
  
  
  
  describe "#random_value" do
    before(:each) do
      Channel.reset_variables
      Channel.reset_names
      Instruction.all_off
      NudgeType.all_off
    end
    
    describe "skeletons" do
      before(:each) do
        IntType.activate
      end
      it "should use a points parameter to set the length" do
        rp = CodeType.random_value(:points => 3)
      end
      
      it "should by default generate a random skeleton" do
        CodeType.should_receive(:random_skeleton).and_return("**")
        rp = CodeType.random_value(:points => 2)
      end
      
      it "should allow a skeleton to be passed in as a param" do
        CodeType.should_not_receive(:random_skeleton)
        rp = CodeType.random_value(:skeleton => "**")
      end
      
      it "should allow a partially filled-in skeleton to be passed in" do
        rp = CodeType.random_value(:skeleton => "* do thing")
        rp.should include(" do thing")
        rp.should_not include("*")
      end
      
      it "should always return a one-line program listing (no linefeeds)" do
        rp = CodeType.random_value(:points => 10, :blocks => 5)
        rp.should_not include("\n")
      end
      
      it "should use '@' as a placeholder that is not replaced with code" do
        rp = CodeType.random_value(:skeleton => "@ do thing")
        rp.should == "@ do thing"
      end
    end
    
    describe "argument checking" do
      it "should raise an ArgumentError if there are no Instructions, References or Types" do
        Channel.reset_variables
        Channel.reset_names
        Instruction.all_off
        NudgeType.all_off
        lambda{CodeType.random_value}.should raise_error
      end
    end
    
    describe "program leaves" do
      describe "instructions" do
        it "should work when there are no active instructions" do
          Channel.bind_variable("x",LiteralPoint.new(:int,12))
          IntType.activate
          lambda{CodeType.random_value}.should_not raise_error
        end
        
        it "should default to a sample of the active instructions" do
          Instruction.should_receive(:active_instructions).and_return([IntAddInstruction])
          CodeType.random_value
        end
        
        it "should allow a list of instructions to be passed in as a param" do
          lambda{CodeType.random_value(:instructions => [IntAddInstruction])}.should_not raise_error
        end
      end
      
      describe "channels" do
        it "should work when there are no active channels" do
          IntAddInstruction.activate
          IntType.activate
          lambda{CodeType.random_value}.should_not raise_error
        end
        
        it "should default to a sample of active variables and names" do
          faked = {"x" => LiteralPoint.new(:int,12)}
          Channel.should_receive(:variables).and_return(faked)
          CodeType.random_value
        end
        
        it "should allow a list of channel names to be passed in as a param" do
          lambda{CodeType.random_value(:references => ["x"])}.should_not raise_error
        end
      end
      
      describe "types" do
        it "should work when there are no active types" do
          Channel.bind_variable("x",LiteralPoint.new(:int,12))
          IntAddInstruction.activate
          lambda{CodeType.random_value}.should_not raise_error
        end
        
        it "should default to a sample of active types" do
          NudgeType.should_receive(:active_types).and_return([IntType])
          CodeType.random_value
        end
        
        it "should allow a list of types to be passed in as a param" do
          lambda{CodeType.random_value(:types => [BoolType])}.should_not raise_error
        end
      end
    end
  end
  
  
  
  describe "roulette_wheel" do
    it "should take three lists as parameters" do
      lambda{CodeType.roulette_wheel()}.should raise_error
      lambda{CodeType.roulette_wheel([1])}.should raise_error
      lambda{CodeType.roulette_wheel([1],[2])}.should raise_error
      lambda{CodeType.roulette_wheel([1],[2],[3])}.should_not raise_error
    end
    
    it "should map its three lists to (references, instructions, types) respectively" do
      CodeType.should_receive(:rand).and_return(1)
      CodeType.roulette_wheel([1],[2],[3]).should == "reference"
      CodeType.should_receive(:rand).and_return(2)
      CodeType.roulette_wheel([1],[2],[3]).should == "instruction"
      CodeType.should_receive(:rand).and_return(3)
      CodeType.roulette_wheel([1],[2],[3]).should == "sample"
    end
    
    it "should raise an exception if a bad value is returned (for next spec)" do
      CodeType.should_receive(:rand).and_return(99)
      lambda{CodeType.roulette_wheel([1],[2],[3])}.should raise_error
    end
    
    it "should have a uniform probability of picking any item" do
      CodeType.should_receive(:rand).and_return(1)
      CodeType.roulette_wheel([1],[2,3],[4,5,6]).should == "reference"
      CodeType.should_receive(:rand).and_return(3)
      CodeType.roulette_wheel([1],[2,3],[4,5,6]).should == "instruction"
      CodeType.should_receive(:rand).and_return(6)
      CodeType.roulette_wheel([1],[2,3],[4,5,6]).should == "sample"
      
      # OK here's the logic: if it's one higher, it'll fail because every entry gets exactly one
      CodeType.should_receive(:rand).and_return(6,7)
      lambda{CodeType.roulette_wheel([1,2,3],[4,5],[6])}.should_not raise_error
      lambda{CodeType.roulette_wheel([1,2,3],[4,5],[6])}.should raise_error
    end
  end

end