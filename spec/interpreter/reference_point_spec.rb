require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge


describe "ReferencePoint" do
  it "should be a kind of program point" do
    myC = ReferencePoint.new("x")
    myC.should be_a_kind_of(ProgramPoint)
  end
  
  it "should have a name parameter with no default" do
    myC = ReferencePoint.new("x")
    myC.name.should == "x"
    lambda {ReferencePoint.new()}.should raise_error(ArgumentError)
  end
  
  describe "#go" do
    before(:each) do
      @ii = Interpreter.new()
      @ii.reset("block{\nref x\nref y\nref z}")
      @ii.bind_variable("x", ValuePoint.new(:float, "1.1"))
      @ii.bind_name("y", ValuePoint.new(:int, "99999"))
      #reference "z" is unbound
    end
    
    it "should pop the exec stack when the program_point ReferencePoint is interpreted" do
      @ii.stacks[:exec].depth.should == 1
      @ii.step
      @ii.stacks[:exec].depth.should == 3
      @ii.step
      @ii.stacks[:exec].depth.should == 3
      @ii.stacks[:exec].peek.raw.should == "1.1"
      2.times {@ii.step}
      @ii.stacks[:exec].depth.should == 2
      @ii.stacks[:exec].peek.raw.should == "99999"
    end
    
    it "should push the ReferencePoint object onto the :name stack if it's not bound" do
      6.times {@ii.step}
      @ii.stacks[:name].depth.should == 1
      @ii.stacks[:name].peek.name.should == "z"
    end

    it "should push the value onto the right stack" do
      3.times {@ii.step}
      @ii.stacks[:float].peek.raw.should == "1.1"
      2.times {@ii.step}
      @ii.stacks[:int].peek.raw.should == "99999"
      @ii.step
      @ii.stacks[:name].peek.name.should == "z"
    end
  end
  
  describe "#tidy" do
    it "should return 'ref x' when the name is 'x'" do
      myC = ReferencePoint.new("x")
      myC.tidy.should == "ref x"
    end
  end
  
  describe "#listing_parts" do
    it "should return an Array containing (1) ReferencePoint#tidy and (2) an empty string" do
      myRP = ReferencePoint.new("bah_8")
      myRP.listing_parts.should == [myRP.tidy,""]
    end
  end
  
  describe "randomize" do
    it "should set the ReferencePoint's name to a randomly selected channel or name key" do
      context = Interpreter.new
      context.reset_variables
      context.reset_names
      myC = ReferencePoint.new("a")
      context.bind_name("y",ValuePoint.new("bool", false))
      myC.randomize(context)
      myC.name.should == "y"
      context.reset_names
      context.bind_variable("z",ValuePoint.new("bool", false))
      myC.randomize(context)
      myC.name.should == "z"
    end
  end
  
  describe "#any" do
    it "should be a class method that returns a completely random instance of a ChannelPoint" do
      context = Interpreter.new
      context.reset_variables
      context.reset_names
      context.bind_name("y",ValuePoint.new("bool", false))
      rC = ReferencePoint.any(context)
      rC.name.should == "y"
      context.reset_names
      context.bind_variable("d",ValuePoint.new("bool", false))
      rC = ReferencePoint.any(context)
      rC.name.should == "d"
    end
  end
end