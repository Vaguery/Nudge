require File.join(File.dirname(__FILE__), "/../spec_helper")

include Nudge

describe "initialization" do
  before(:each) do
    @ii = Interpreter.new()
  end
  
  it "should have a #parser, which defaults to a new NudgeLanguageParser" do
    @ii.parser.should be_a_kind_of(NudgeLanguageParser)
  end
  
  it "should have a #stacks attribute, a hash" do
    @ii.stacks.should == {}
  end
  
  it "should respond to #load(listing) by parsing the listing and pushing it onto its exec stack" do
    checker = NudgeLanguageParser.new()
    myCode = "channel x"
    @ii.load(myCode)
    @ii.stacks.should include("exec")
    @ii.stacks["exec"].should be_a_kind_of(Stack)
    @ii.stacks["exec"].depth.should == 1
    @ii.stacks["exec"].peek.should be_a_kind_of(Channel)
    @ii.stacks["exec"].peek.name.should == checker.parse(myCode).to_points.name
  end
  
  it "should respond work for a complex CodeBlock too" do
    checker = NudgeLanguageParser.new()
    myCode = "block {\ninstr foo\n instr bar\n block {\ninstr baz}}"
    @ii.load(myCode)
    @ii.stacks.should include("exec")
    @ii.stacks["exec"].should be_a_kind_of(Stack)
    @ii.stacks["exec"].depth.should == 1
    whatGotPushed = @ii.stacks["exec"].peek
    whatGotPushed.should be_a_kind_of(CodeBlock)
    whatGotPushed.contents.length.should == checker.parse(myCode).to_points.contents.length
    whatGotPushed.contents[1].name.should == "bar"
    whatGotPushed.contents[2].contents[0].name.should == "baz"
  end
  
  it "should accept a listing, which should default to an empty string" do
    ij = Interpreter.new("literal int,7")
    ij.stacks["exec"].peek.should be_a_kind_of(Literal)
  end
  
  
end