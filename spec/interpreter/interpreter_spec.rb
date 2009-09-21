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
  
  it "should respond to #load(listing) by parsing the listing and pushing it onto its exec stack" do
    checker = NudgeLanguageParser.new()
    myCode = "channel x"
    @ii.load(myCode)
    Stack.stacks.should include(:exec)
    Stack.stacks[:exec].should be_a_kind_of(Stack)
    Stack.stacks[:exec].depth.should == 1
    Stack.stacks[:exec].peek.should be_a_kind_of(Channel)
    Stack.stacks[:exec].peek.name.should == checker.parse(myCode).to_points.name
  end
  
  it "should load a complex CodeBlock as a single item on the exec stack" do
    checker = NudgeLanguageParser.new()
    myCode = "block {\ninstr foo\n instr bar\n block {\ninstr baz}}"
    @ii.load(myCode)
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
    Stack.stacks[:int] = Stack.new(:int)
    @ii.load("literal int,999")
  end
  
  describe "literals" do
    it "should pop the exec stack when it interprets a Literal" do
      oldExec = Stack.stacks[:exec].depth
      @ii.step
      Stack.stacks[:exec].depth.should == (oldExec-1)
    end
    it "should initialize the right stack for the type fo the Literal if it doesn't exist" do
      Stack.stacks.delete("int")
      @ii.step
      Stack.stacks.should include("int")
    end
    it "should use the existing stack if it does exist"
    it "should push the value onto the right stack"
    it "should check for CODE size limits"
  end
  
  
  describe "instructions" do
    before(:each) do
      @ii = Interpreter.new()
    end


    it "should pop the exec stack when it interprets an instruction"
    
    it "should check to see if the instruction name is in its Library"
  end
end
