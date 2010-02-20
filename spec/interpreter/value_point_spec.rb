#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "ValuePoint" do
  it "should be a kind of program point" do
    myL = ValuePoint.new("int", "4")
    myL.should be_a_kind_of(ProgramPoint)
  end
  
  it "should be initialized with a type and a value as strings, with value defaulting to nil" do
    i4 = ValuePoint.new("int", "4")
    i4.type.should == :int
    i4.value.should == "4"
    lambda{ValuePoint.new()}.should raise_error(ArgumentError)
    lambda{ValuePoint.new("bool")}.should_not raise_error(ArgumentError)
  end
  
  it "should accept a string or symbol for #value, but set it to a symbol" do
    ValuePoint.new("int", "4").type.should == :int
    ValuePoint.new(:int, "4").type.should == :int
  end
  
  it "should move to the appropriate stack when removed from the exec stack" do
    pending
    # ii = Interpreter.new(program:"value bool (true)")
    # ii.step
    # ii.stacks[:bool].peek.value.should == true
  end
  
  describe "#go" do
    before(:each) do
      @ii = Interpreter.new()
      @ii.clear_stacks
      @ii.stacks[:exec].push(ValuePoint.new("int","222"))
    end
    
    it "should pop the exec stack when a ValuePoint is interpreted" do
      oldExec = @ii.stacks[:exec].depth
      @ii.step
      @ii.stacks[:exec].depth.should == (oldExec-1)
    end
    
    it "should initialize the right stack for the type of the ValuePoint if it doesn't exist" do
      @ii.stacks.delete(:int)
      @ii.step
      @ii.stacks.should include(:int)
    end
    
    it "should use the existing stack if it does exist" do
      @ii.step
      @ii.stacks[:int].depth.should == 1
    end

    it "should push the value onto the right stack" do
      @ii.stacks[:exec].push(ValuePoint.new("int","3"))
      @ii.stacks[:exec].push(ValuePoint.new("float","2.2"))
      @ii.stacks[:exec].push(ValuePoint.new("fiddle","false"))
      
      3.times {@ii.step}
      @ii.stacks.should include(:int)
      @ii.stacks.should include(:float)
      @ii.stacks.should include(:fiddle)
    end
  end
  
  describe "#tidy" do
    it "should print 'value «type»' for ValuePoint#tidy" do
      myL = ValuePoint.new("float", "-99.121001")
      myL.tidy.should == "value «float»"
    end
  end
  
  describe "randomize" do
    before(:each) do
      @ii = Interpreter.new()
      @ii.enable_all_types
    end
    
    it "should return one of the active types (not one of the defined types!)" do
      myL = ValuePoint.new("int", "77")
      @ii.disable_all_types
      @ii.enable(BoolType)
      myL.randomize(@ii)
      myL.type.should == :bool
    end
  end
  
  describe "random CodeType should not be a problem" do
    it "should have a valid code type and a value that parses" do
      pending
      @ii = Interpreter.new()
      @ii.disable_all_types
      @ii.disable_all_instructions
      @ii.enable(CodeType)
      lambda{ValuePoint.any(@ii)}.should raise_error(ArgumentError, "Random code cannot be created")
    end
  end
end