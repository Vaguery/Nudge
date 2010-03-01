#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "ValuePoint" do
  it "should be a kind of program point" do
    myL = ValuePoint.new("int", "4")
    myL.should be_a_kind_of(ProgramPoint)
  end
  
  
  it "should be initialized with a type and a raw value, with raw defaulting to nil" do
    i4 = ValuePoint.new("int", "4")
    i4.type.should == :int
    i4.raw.should == "4"
    lambda{ValuePoint.new()}.should raise_error(ArgumentError)
    lambda{ValuePoint.new("bool")}.should_not raise_error(ArgumentError)
  end
  
  
  describe "raw" do
    it "should cast the representation of the thing as a string unless nil" do
      lambda{ValuePoint.new("anything", "something")}.should_not raise_error(ArgumentError)
      ValuePoint.new("fiddlefaddle", 88).raw.should == "88"
      ValuePoint.new("int", 8).raw.should == "8"
    end
  end
  
  
  describe "nudgetype" do
    it "should be able to identify its NudgeType, and if it's defined" do
      ValuePoint.new("int").nudgetype.should == "IntType"
      ValuePoint.new("int").nudgetype_defined?.should == true
      ValuePoint.new("bool").nudgetype_defined?.should == true
      ValuePoint.new("float").nudgetype_defined?.should == true
      
      ValuePoint.new("foo").nudgetype.should == "FooType"
      ValuePoint.new("foo").nudgetype_defined?.should == false
    end
  end
  
  
  describe "#value" do
    it "should use the #from_s method from the appropriate NudgeType" do
      ValuePoint.new("int",9912).value.should == 9912
      ValuePoint.new("float",1.2).value.should == 1.2
      ValuePoint.new("bool",false).value.should == false
    end
    
    it "should not create a value if none is present in #raw" do
      ValuePoint.new("int").value.should == nil
      ValuePoint.new("float").value.should == nil
      ValuePoint.new("bool",nil).value.should == nil
    end
    
    it "should return nil as a value if the type is not defined" do
      left_field = ValuePoint.new("foo", "some weird thing")
      left_field.value.should == nil
      left_field.raw.should == "some weird thing"
    end
    
  end
  
  
  it "should accept a string or symbol for #type, but set it to a symbol" do
    ValuePoint.new("int", "4").type.should == :int
    ValuePoint.new(:int, "4").type.should == :int
    lambda {ValuePoint.new(false, "4")}.should raise_error(ArgumentError)
  end
  
  
  it "should move to the appropriate stack when removed from the exec stack" do
    ii = Interpreter.new(program:"value «bool»\n«bool»true")
    ii.step
    ii.stacks[:bool].peek.raw.should == "true"
    
    ii.reset("value «code» \n«code» block { do foo_bar}")
    ii.step
    ii.stacks[:code].peek.raw.should == "block { do foo_bar}"
  end
  
  
  describe "#go" do
    before(:each) do
      @ii = Interpreter.new()
      @ii.clear_stacks
      @ii.stacks[:exec].push(ValuePoint.new("int",222))
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
      @ii.stacks[:exec].push(ValuePoint.new("int",3))
      @ii.stacks[:exec].push(ValuePoint.new("float",2.2))
      @ii.stacks[:exec].push(ValuePoint.new("fiddle",false))
      
      3.times {@ii.step}
      @ii.stacks.should include(:int)
      @ii.stacks.should include(:float)
      @ii.stacks.should include(:fiddle)
    end
  end
  
  
  describe "#tidy" do
    it "should print 'value «type»' for ValuePoint#tidy" do
      myL = ValuePoint.new("float", -99.121001)
      myL.tidy.should == "value «float»"
    end
  end
  
  
  describe "#listing_parts" do
    it "should description return an Array with two parts: (1) self#tidy (2) the footnotes as a string" do
      myL = ValuePoint.new("float", "-99.121001")
      myL.listing_parts.should == ["value «float»","«float» -99.121001"]
      myURI = ValuePoint.new("uri", "http://googol.com")
      myURI.listing_parts.should == ["value «uri»","«uri» http://googol.com"]
      
      myHuh = ValuePoint.new("missing")
      myHuh.listing_parts.should == ["value «missing»",""]
      
      myFUcode = ValuePoint.new("code", "block { value «code»}\n«code» value «int»\n«int» 8")
      myFUcode.listing_parts.should == ["value «code»","«code» block { value «code»}\n«code» value «int»\n«int» 8"]
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
      lambda{ValuePoint.any(@ii)}.should_not raise_error
    end
  end
end