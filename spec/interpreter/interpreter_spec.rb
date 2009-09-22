require File.join(File.dirname(__FILE__), "/../spec_helper")

include Nudge

describe "initialization" do
  before(:each) do
    @ii = Interpreter.new()
    Stack.cleanup
  end
  
  it "should have a #parser, which defaults to a new NudgeLanguageParser" do
    @ii.parser.should be_a_kind_of(NudgeLanguageParser)
  end
  
  it "should respond to #reset(listing) by parsing the listing and pushing it onto its exec stack" do
    checker = NudgeLanguageParser.new()
    myCode = "channel x"
    @ii.reset(myCode)
    Stack.stacks.should include(:exec)
    Stack.stacks[:exec].should be_a_kind_of(Stack)
    Stack.stacks[:exec].depth.should == 1
    Stack.stacks[:exec].peek.should be_a_kind_of(Channel)
    Stack.stacks[:exec].peek.name.should == checker.parse(myCode).to_points.name
  end
  
  it "should load a complex CodeBlock as a single item on the exec stack" do
    checker = NudgeLanguageParser.new()
    myCode = "block {\ninstr foo\n instr bar\n block {\ninstr baz}}"
    @ii.reset(myCode)
    Stack.stacks.should include(:exec)
    Stack.stacks[:exec].depth.should == 1
    whatGotPushed = Stack.stacks[:exec].peek
    whatGotPushed.should be_a_kind_of(CodeBlock)
    whatGotPushed.contents.length.should == checker.parse(myCode).to_points.contents.length
    whatGotPushed.contents[1].name.should == "bar"
    whatGotPushed.contents[2].contents[0].name.should == "baz"
  end
  
  it "should accept a listing, which should default to an empty string" do
    ij = Interpreter.new("literal int,7")
    Stack.stacks[:exec].peek.should be_a_kind_of(Literal)
  end
end

describe "stepping" do
  before(:each) do
    @ii = Interpreter.new()
    Stack.cleanup
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
    Stack.cleanup
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
