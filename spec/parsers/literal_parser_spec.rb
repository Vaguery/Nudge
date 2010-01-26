require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('literal')
include Nudge

describe NudgeLiteralParser do
  before(:each) do
    @parser = NudgeLiteralParser.new()
  end
  
  it { should parse("literal int(8)") }
  it { should parse("literal float(8.2)") }
  it { should parse("literal string(I am a string)") }
  it { should parse('literal string(\()') }
  it { should parse('literal string(  anything at all  )') }
  it { should parse('literal string(literal code literal \(\)\(\(\(\)\) \) )') }
  it { pending; should parse('literal string(i end in a slash\\)') }
  
  
  
  it { should_not parse('literal string()') }
  it { pending; should_not parse('literal string( )') }
  
  
  
  
  
  
  describe "captures" do
    before(:each) do
      @parsed = @parser.parse("literal int(8)")
    end
  end
  
  
end
