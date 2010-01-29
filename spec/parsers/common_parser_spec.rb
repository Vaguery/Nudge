#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('common')
include Nudge

describe NudgeCommonParser do
  before(:each) do
    @parser = NudgeCommonParser.new()
  end
  
  it { should parse(" ") }
  it { should parse("  ") }
  it { should parse("\t ") }
  it { should parse("\n ") }
  
  it { should parse("hi_there") }
  it { should parse("oneword") }
  it { should_not parse("_this") }
  it { should_not parse("9this") }
  
  it { should parse("unicoɷʦƞ_2") } # as an alphas_and_underscores
end
