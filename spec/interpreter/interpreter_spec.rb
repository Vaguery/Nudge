require File.join(File.dirname(__FILE__), "/../spec_helper")

include Nudge

describe "parser" do
  it "should have a #parser, which defaults to a new NudgeLanguageParser" do
    ii = Interpreter.new()
    ii.parser.should be_a_kind_of(NudgeLanguageParser)
  end
end