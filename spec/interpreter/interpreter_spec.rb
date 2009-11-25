require File.join(File.dirname(__FILE__), "/../spec_helper")

include Nudge

describe "initialization" do
  before(:each) do
    @ii = Interpreter.new()
    @ii.clear_stacks
  end
  
  it "should have a #parser, which defaults to a new NudgeLanguageParser" do
    @ii.parser.should be_a_kind_of(NudgeLanguageParser)
  end
  
  it "should have an empty stacks Hash, empty initially" do
    @ii.stacks.should == {}
  end
  
  it "should keep have an empty instructions attribute, a Hash" do
    @ii.instructions_library.should == Hash.new
  end
  
  it "should automatically create an entry if an unmentioned stack is referenced by a method" do
    lambda{@ii.stacks[:pirate].peek}.should_not raise_error
    @ii.stacks.should include(:pirate)
    
    @ii.stacks.should_not include(:ninja) 
    lambda{@ii.stacks[:ninja].depth}.should_not raise_error
    @ii.stacks.should include(:ninja)
    
    @ii.stacks.should_not include(:robot)
    lambda{@ii.stacks[:robot].pop}.should_not raise_error
    @ii.stacks.should include(:robot)
  end
  
  it "should respond to #reset(listing) by parsing the listing and pushing it onto its exec stack" do
    checker = NudgeLanguageParser.new()
    myCode = "ref x"
    @ii.reset(myCode)
    @ii.stacks.should include(:exec)
    @ii.stacks[:exec].should be_a_kind_of(Stack)
    @ii.stacks[:exec].depth.should == 1
    @ii.stacks[:exec].peek.should be_a_kind_of(ChannelPoint)
    @ii.stacks[:exec].peek.name.should == checker.parse(myCode).to_points.name
  end
  
  it "#reset should reset the #steps counter, too" do
    @ii.steps = 100
    @ii.reset("channel x")
    @ii.steps.should == 0
  end
  
  it "should load a complex CodeBlock as a single item on the exec stack" do
    checker = NudgeLanguageParser.new()
    myCode = "block {\ndo foo\n do bar\n block {\ndo baz}}"
    @ii.reset(myCode)
    @ii.stacks.should include(:exec)
    @ii.stacks[:exec].depth.should == 1
    whatGotPushed = @ii.stacks[:exec].peek
    whatGotPushed.should be_a_kind_of(CodeBlock)
    whatGotPushed.contents.length.should == checker.parse(myCode).to_points.contents.length
    whatGotPushed.contents[1].name.should == "bar"
    whatGotPushed.contents[2].contents[0].name.should == "baz"
  end
  
  it "should accept a listing, which should default to an empty string" do
    ij = Interpreter.new(program:"literal int(7)")
    ij.stacks[:exec].peek.should be_a_kind_of(LiteralPoint)
  end
  
  it "should have an #enable method that works for Instructions, adding them to the #instructions hash" do
    @ii.instructions_library.should == {}
    @ii.enable(IntAddInstruction)
    @ii.instructions_library[IntAddInstruction].should_not== nil
    @ii.instructions_library[IntAddInstruction].should be_a_kind_of(IntAddInstruction)
    @ii.instructions_library[IntAddInstruction].context.should == @ii
  end
  
  it "should have an #enable_all_instructions method" do
    @ii.instructions_library.should == {}
    @ii.enable_all_instructions
    @ii.instructions_library.keys.should == Instruction.all_instructions
  end
  
  it "should have a #disable_all_instructions method" do
    @ii.enable_all_instructions
    @ii.instructions_library.should_not == {}
    @ii.disable_all_instructions
    @ii.instructions_library.should == {}
  end
  
  it "should have a #disable method that removes Instructions from the #instructions hash" do
    @ii.enable(IntAddInstruction)
    @ii.instructions_library[IntAddInstruction].should_not == nil
    @ii.disable(IntAddInstruction)
    @ii.instructions_library.should_not include(IntAddInstruction)
  end
  
  describe "variables table" do
    it "should be an empty hash initially (by deafult)" do
      @ii.variables.should == {}
    end

    it "should create a new entry when #bind_variable is called" do
      @ii.bind_variable("x",LiteralPoint.new(:int,88))
      @ii.variables["x"].should be_a_kind_of(LiteralPoint)
      @ii.variables["x"].type.should == :int
      @ii.variables["x"].value.should == 88
    end
    
    it "should raise an exception if the bound value is anything but a LiteralPoint" do
      lambda {@ii.bind_variable("x", 88)}.should raise_error(ArgumentError)
      lambda {@ii.bind_variable("x", [1,2])}.should raise_error(ArgumentError)
      lambda {@ii.bind_variable("x", nil)}.should raise_error(ArgumentError)
    end
    
    it "should remove an new entry when #unbind_variable is called" do
      @ii.bind_variable("x",LiteralPoint.new(:int,88))
      @ii.variables["x"].value.should == 88
      @ii.unbind_variable("x")
      @ii.variables["x"].should == nil
    end
    
    it "should be resettable" do
      @ii.bind_variable("x",LiteralPoint.new(:int,88))
      @ii.reset_variables
      @ii.variables.should_not include("x")
    end
  end
  
  describe "names table" do
    it "should be an empty hash initially" do
      @ii.names.should == {}
    end
  
    it "should create a new entry when #bind_name is called" do
      @ii.bind_name("x",LiteralPoint.new(:bool,false))
      @ii.names["x"].should be_a_kind_of(LiteralPoint)
      @ii.names["x"].type.should == :bool
      @ii.names["x"].value.should == false
    end

    it "should raise an exception if the bound value is anything but a LiteralPoint" do
      lambda {@ii.bind_name("x", 88)}.should raise_error(ArgumentError)
      lambda {@ii.bind_name("x", [1,2])}.should raise_error(ArgumentError)
      lambda {@ii.bind_name("x", nil)}.should raise_error(ArgumentError)
    end
    
    it "should remove an new entry when #unbind_name is called" do
      @ii.bind_name("x",LiteralPoint.new(:int,88))
      @ii.names["x"].value.should == 88
      @ii.unbind_name("x")
      @ii.names["x"].should == nil
    end
    
    it "should be resettable" do
      @ii.bind_name("x",LiteralPoint.new(:int,88))
      @ii.reset_names
      @ii.names.should_not include("x")
    end
  end
  
  describe "references" do
    it "should return an Array of keys obtained by mergine variables into names (not vice versa)" do
      @ii.bind_name("x",LiteralPoint.new(:int,88))
      @ii.bind_variable("y",LiteralPoint.new(:int,88))
      @ii.bind_name("y",LiteralPoint.new(:bool,false))
      @ii.references.should == @ii.names.merge(@ii.variables).keys
      @ii.references.should_not == @ii.variables.merge(@ii.names).keys
    end
  end
  
  describe "Type list" do
    it "should have a #types attribute whis defaults to NudgeType.all_types" do
      @ii.types.should == NudgeType.all_types
    end
    
    it "should have a #enable_all_types/#disable_all_types methods that turn on and off all active types" do
      @ii.enable(BoolType)
      @ii.disable_all_types
      @ii.types.should_not include(BoolType)
      @ii.enable_all_types
      @ii.types.should == NudgeType.all_types
    end

    it "should have #enable/#disable methods that add and remove the types from #types list" do
      @ii.enable(IntType)
      @ii.enable(BoolType)
      @ii.disable(IntType)
      @ii.active?(IntType).should == false
      @ii.active?(BoolType).should == true
      @ii.enable(IntType)
      @ii.active?(IntType).should == true
      @ii.active?(BoolType).should == true
    end

    it "should only ever have one copy of a type on the list at once" do
      @ii.disable_all_types
      @ii.enable(IntType)
      @ii.enable(IntType)
      @ii.enable(IntType)
      @ii.types.length.should == 1
    end
  end
  
end

describe "stepping" do
  before(:each) do
    @ii = Interpreter.new()
    @ii.clear_stacks
  end
  
  it "should step only until the :exec stack is empty (if the PointLimit has not been reached)" do
    myCode = "block {}"
    @ii.reset(myCode)
    lambda{3.times {@ii.step}}.should_not raise_error 
  end
  
  it "should step only until the stepLimit has not been reached, if the :exec stack is full" do
    myCode = "block {"*20 + "}"*20
    @ii.stepLimit = 3
    @ii.reset(myCode)
    lambda{15.times {@ii.step}}.should_not raise_error
  end
  
  it "should count how many steps are executed" do
    myCode = "block {"*20 + "}"*20
    @ii.reset(myCode)
    11.times {@ii.step}
    @ii.steps.should == 11
    11.times {@ii.step}
    @ii.steps.should == 20
  end
  
end

describe "running" do
  before(:each) do
    @ii = Interpreter.new()
    @ii.clear_stacks
    myCode = "block {"*20 + "}"*20
    @ii.reset(myCode)
  end
  
  it "should run until the stepLimit has been reached, if the :exec stack isn't empty" do
    @ii.stepLimit = 9
    @ii.run
    @ii.steps.should == 9
  end
  
  it "should run until the :exec stack is empty (if the PointLimit has not been reached)" do
    @ii.run
    @ii.steps.should == 20
  end
  
  it "should do nothing if the :exec stack starts empty" do
    @ii.reset()
    @ii.run
    @ii.steps.should == 0
  end
  
end

describe "channel setup" do
end
