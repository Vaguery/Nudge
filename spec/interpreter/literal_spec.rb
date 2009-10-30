require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "LiteralPoint" do
  
    it "should be a kind of program point" do
      myL = LiteralPoint.new("int", 4)
      myL.should be_a_kind_of(ProgramPoint)
    end
    
    it "should be initialized with a type and a value, with no defaults" do
      myL = LiteralPoint.new("int", 4)
      myL.should be_a_kind_of(LiteralPoint)
      myL.type.should == :int
      myL.value.should == 4
      lambda{LiteralPoint.new()}.should raise_error(ArgumentError)
      lambda{LiteralPoint.new("bool")}.should raise_error(ArgumentError)
    end
    
    it "should move to the appropriate stack when removed from the exec stack" do
      ii = Interpreter.new("literal bool (true)")
      ii.step
      ii.stacks[:bool].peek.value.should == true
    end
    
    describe "#go" do
      before(:each) do
        @ii = Interpreter.new()
        @ii.clear_stacks
        @ii.stacks[:int] = Stack.new(:int)
        @ii.reset("literal int (999)")
      end
      
      it "should pop the exec stack when a LiteralPoint is interpreted" do
        oldExec = @ii.stacks[:exec].depth
        @ii.step
        @ii.stacks[:exec].depth.should == (oldExec-1)
      end
      
      it "should initialize the right stack for the type of the LiteralPoint if it doesn't exist" do
        @ii.stacks.delete(:int)
        @ii.step
        @ii.stacks.should include(:int)
      end
      
      it "should use the existing stack if it does exist" do
        @ii.step
        @ii.stacks[:int].depth.should == 1
      end

      it "should push the value onto the right stack" do
        @ii.stacks[:exec].push(LiteralPoint.new("int",3))
        @ii.stacks[:exec].push(LiteralPoint.new("float",2.2))
        @ii.stacks[:exec].push(LiteralPoint.new("bool",false))
        
        3.times {@ii.step}
        @ii.stacks.should include(:int)
        @ii.stacks.should include(:float)
        @ii.stacks.should include(:bool)
      end
    end
    
    describe "#tidy" do
      it "should print 'literal type, value' for LiteralPoint#tidy" do
        myL = LiteralPoint.new("float", -99.121001)
        myL.tidy.should == "literal float (-99.121001)"
      end
    end
    
    describe "randomize" do
      before(:each) do
        @ii = Interpreter.new()
        @ii.enable_all_types
      end
      
      it "should return one of the active types (not one of the defined types!)" do
        myL = LiteralPoint.new("int", 77)
        @ii.disable_all_types
        @ii.enable(BoolType)
        myL.randomize(@ii)
        myL.type.should == "bool"
      end
    end
    
    describe "random CodeType should not be a problem" do
      it "should have a valid code type and a value that parses" do
        @ii = Interpreter.new()
        @ii.disable_all_types
        @ii.disable_all_instructions
        @ii.enable(CodeType)
        lambda{LiteralPoint.any(@ii)}.should raise_error(ArgumentError, "Random code cannot be created")
      end
    end
end