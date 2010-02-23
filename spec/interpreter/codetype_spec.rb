require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge
describe "Code Type" do
  
  it "should return the result of self.randomize when it receives an #any_value call" do
    CodeType.should_receive(:random_value).and_return("hi there!")
    CodeType.any_value(Interpreter.new).should == "hi there!"
  end
  
  
  it "should have a #recognizes? method that returns true if the arg is something it can read" do
    pending
    # examples from FLoatType:
    # FloatType.recognizes?(3.991).should == true
    # FloatType.recognizes?(-3.99129).should == true
    # FloatType.recognizes?(3).should == true
    # FloatType.recognizes?(Complex(2,3)).should == true
    # FloatType.recognizes?(Rational("2/3")).should == true
    # 
    # FloatType.recognizes?(nil).should == false
    # FloatType.recognizes?("2.123").should == false
    # FloatType.recognizes?([1.1, 2.2, 3.3]).should == false
    # FloatType.recognizes?(Object.new).should == false
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
    before(:each) do
      @context = Interpreter.new
    end
    
    it "should return a single sample from the #types method of the context passed in" do
      @context = Interpreter.new
      @context.disable_all_types
      @context.enable(IntType)
      CodeType.any_type(@context.types).should == IntType
    end
    
    it "should default to the list of active types in the context" do
      @context.disable_all_types
      @context.enable(IntType)
      CodeType.any_type(@context.types).should == IntType
    end
    
    it "should raise an error if the list of active_types is empty and none is passed in" do
      @context.disable_all_types
      lambda{CodeType.any_type(@context.types)}.should raise_error(ArgumentError)
    end
    
    it "should raise an error if the list of types passed in is empty" do
      @context.disable_all_types
      lambda{CodeType.any_type(@context.types)}.should raise_error(ArgumentError)
    end
  end
  
  
  
  describe "any_instruction" do
    before(:each) do
      @context = Interpreter.new
    end
    
    it "should return a single sample from the context passed in (no implied validation)" do
      @context.disable_all_instructions
      @context.enable(IntAddInstruction)
      CodeType.any_instruction(@context.instructions).should == IntAddInstruction
    end
    
    it "should raise an error if the no instructions are active in the context and none are passed in" do
      @context.disable_all_instructions
      lambda{CodeType.any_instruction(@context.instructions)}.should raise_error(ArgumentError)
    end
  end
  
  describe "any_reference" do
    before(:each) do
      @context = Interpreter.new
    end
  
    it "should return a random reference from the context" do
      @context.reset_variables
      @context.bind_variable("x",ValuePoint.new(:int,"12"))
      CodeType.any_reference(@context.references).should == "x"
    end
    
    
    it "should raise an error if the list of active references is empty" do
      @context.reset_variables
      @context.reset_names
      lambda{CodeType.any_reference(@context.references)}.should raise_error(ArgumentError)
    end
  end
  
  
  
  describe "#random_value" do
    before(:each) do
      @context = Interpreter.new
      @context.reset_variables
      @context.reset_names
      @context.disable_all_instructions
      @context.disable_all_types
    end
    
    describe "skeletons" do
      before(:each) do
        @context.enable(IntType)
      end
      
      it "should use a points parameter to set the length" do
        rp = CodeType.random_value(@context,:points => 3)
      end
      
      it "should by default generate a random skeleton" do
        CodeType.should_receive(:random_skeleton).and_return("**")
        rp = CodeType.random_value(@context,:points => 2)
      end
      
      it "should allow a skeleton to be passed in as a param" do
        CodeType.should_not_receive(:random_skeleton)
        rp = CodeType.random_value(@context,:skeleton => "**")
      end
      
      it "should allow a partially filled-in skeleton to be passed in" do
        rp = CodeType.random_value(@context,:skeleton => "* do thing")
        rp.should include(" do thing")
        rp.should_not include("*")
      end
      
      it "should always return a one-line program listing (no linefeeds)" do
        rp = CodeType.random_value(@context, :points => 10, :blocks => 5)
        rp.should_not include("\n")
      end
      
      it "should use '@' as a placeholder that is not replaced with code" do
        rp = CodeType.random_value(@context, :skeleton => "@ do thing")
        rp.should == "@ do thing"
      end
    end
    
    describe "argument checking" do
      it "should raise an ArgumentError if there are no Instructions, References or Types" do
        @context.reset_variables
        @context.reset_names
        @context.disable_all_types
        @context.disable_all_instructions
        lambda{CodeType.random_value(@context)}.should raise_error
      end
    end
    
    describe "program leaves" do
      describe "instructions" do
        it "should work when there are no active instructions" do
          @context.bind_variable("x",ValuePoint.new(:int,"12"))
          @context.enable(IntType)
          lambda{CodeType.random_value(@context)}.should_not raise_error
        end
        
        it "should default to a sample of the active instructions" do
          @context.should_receive(:instructions).and_return([IntAddInstruction])
          CodeType.random_value(@context)
        end
        
        it "should allow a list of instructions to be passed in as a param" do
          lambda{CodeType.random_value(@context,:instructions => [IntAddInstruction])}.should_not raise_error
        end
      end
      
      describe "channels" do
        it "should work when there are no active channels" do
          @context.enable(IntAddInstruction)
          @context.enable(IntType)
          lambda{CodeType.random_value(@context)}.should_not raise_error
        end
        
        it "should default to a sample of active variables and names" do
          @context.should_receive(:references).and_return(["x"])
          CodeType.random_value(@context)
        end
        
        it "should allow a list of channel names to be passed in as a param" do
          lambda{CodeType.random_value(@context,:references => ["x"])}.should_not raise_error
        end
      end
      
      describe "types" do
        it "should work when there are no active types" do
          @context.bind_variable("x",ValuePoint.new(:int,"12"))
          @context.enable(IntAddInstruction)
          lambda{CodeType.random_value(@context)}.should_not raise_error
        end
        
        it "should default to a sample of active types" do
          @context.should_receive(:types).and_return([IntType])
          CodeType.random_value(@context)
        end
        
        it "should allow a list of types to be passed in as a param" do
          lambda{CodeType.random_value(@context,:types => [BoolType])}.should_not raise_error
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