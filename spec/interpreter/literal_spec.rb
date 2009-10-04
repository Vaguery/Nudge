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
      Stack.stacks[:bool].peek.value.should == true
    end
    
    describe "#go" do
      before(:each) do
        @ii = Interpreter.new()
        Stack.cleanup
        Stack.stacks[:int] = Stack.new(:int)
        @ii.reset("literal int (999)")
      end
      
      it "should pop the exec stack when a LiteralPoint is interpreted" do
        oldExec = Stack.stacks[:exec].depth
        @ii.step
        Stack.stacks[:exec].depth.should == (oldExec-1)
      end
      
      it "should initialize the right stack for the type of the LiteralPoint if it doesn't exist" do
        Stack.stacks.delete(:int)
        @ii.step
        Stack.stacks.should include(:int)
      end
      
      it "should use the existing stack if it does exist" do
        @ii.step
        Stack.stacks[:int].depth.should == 1
      end

      it "should push the value onto the right stack" do
        Stack.stacks[:exec].push(LiteralPoint.new("int",3))
        Stack.stacks[:exec].push(LiteralPoint.new("float",2.2))
        Stack.stacks[:exec].push(LiteralPoint.new("bool",false))
        
        3.times {@ii.step}
        Stack.stacks.should include(:int)
        Stack.stacks.should include(:float)
        Stack.stacks.should include(:bool)
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
        NudgeType.all_types.each {|t| t.activate}
      end
      after(:each) do
        NudgeType.all_types.each {|t| t.activate}
      end
      it "should return one of the active types (not one of the defined types!)" do
        myL = LiteralPoint.new("int", 77)
        NudgeType.all_types.each {|t| t.deactivate}
        BoolType.activate
        myL.randomize
        myL.type.should == "bool"
      end
    end
    
    describe "random CodeType should not be a problem" do
      it "should have a valid code type and a value that parses" do
        pending "this will only work when the parser can recognize code literals!"
        NudgeType.all_types.each {|t| t.deactivate}
        CodeType.activate
        rL = LiteralPoint.any
        rL.type.should == "code"
        p rL.value
        myP = NudgeLanguageParser.new()
        myP.parse(rL.value).should_not == nil
        p myP.parse(rL.value).to_points.tidy
      end
    end
    
    
    describe "any" do
      it "should return a new instance of a Literal, invoking #randomize, but should return CodeTypes that are 'safe for listing'" do
        pending "There needs to be a new default beahvior that eliminates 'unprintable' types from the randomizers"
        rL = LiteralPoint.any
        rL.should be_a_kind_of(LiteralPoint)
        rL.type.should_not == "code"
      end
    end
end