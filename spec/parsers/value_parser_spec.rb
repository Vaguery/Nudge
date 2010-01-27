require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('value')
include Nudge

describe NudgeValueParser do
  before(:each) do
    @parser = NudgeValueParser.new()
  end
  
  it { should parse("value int (8)") }
  it { should parse("value float(111)") }
  it { should parse('value anything    (9999999999999999999)') }
  
  it { should_not parse('value float(2.1)') }
  it { should_not parse('value bool(false))') }
  it { should_not parse('value bool(false))') }
  
  
  describe "captures" do
    before(:each) do
      @parsed = @parser.parse("value int(8)")
    end
    
    it { should capture(:type).as('int') }
    it { should capture(:footnote_number).as('8') }
  end
end
