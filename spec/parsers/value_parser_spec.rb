# encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('value')
include Nudge

describe NudgeValueParser do
  before(:each) do
    @parser = NudgeValueParser.new()
  end
  
  it { should parse("value «8»") }
  it { should parse("value «111»") }
  it { should parse('value    «9999999999999999999»') }
  
  # deprecated syntax
  it { should_not parse('value float(2.1)') }
  it { should_not parse('value bool(false)') }
  it { should_not parse('value bool(false)') }
  
  
  describe "captures" do
    before(:each) do
      @parsed = @parser.parse("value «8»")
    end
    
    it { should capture(:footnote_number).as('8') }
  end
end
