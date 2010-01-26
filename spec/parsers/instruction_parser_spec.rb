require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('instruction')
include Nudge

describe NudgeCommonParser do
  before(:each) do
    @parser = NudgeInstructionParser.new()
  end
  
  it { should parse("do int_add") }
  it { should parse("do anything") }
  it { should_not parse("do _int_add") }
  it { should_not parse("do 9int_add") }
  it { should parse("do Int_ADD") }
  
  it { should_not parse("do is_real?") }
  
  describe "captures" do
    before(:each) do
      @parsed = @parser.parse("do int_ADD")
    end
    it { should capture(:opcode).as('int_ADD') }
  end
end
