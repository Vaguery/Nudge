require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('channel')
include Nudge

describe NudgeChannelParser do
  before(:each) do
    @parser = NudgeChannelParser.new()
  end
  
  it { should parse("ref x1") }
  it { should parse("ref h_") }
  it { should_not parse("ref _x1") }
  it { should_not parse("ref 1x1") }
  
  describe "captures" do
    before(:each) do
      @parsed = @parser.parse("ref x_99_agent")
    end
    
    it { should capture(:channel_name).as('x_99_agent') }
  end
  
  describe "Nudge node subclasses and methods" do
    before(:each) do
      @parsed = @parser.parse("ref v")
    end
    
    it "should return a SyntaxNode that is a ChannelNode" do
      @parsed.should be_a_kind_of(ChannelNode)
    end
  end
end
