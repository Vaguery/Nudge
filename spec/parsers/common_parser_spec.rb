#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('common')
include Nudge

describe NudgeCommonParser do
  before(:each) do
    @parser = NudgeCommonParser.new()
  end
  
  it { should treetop_parse(" ") }
  it { should treetop_parse("  ") }
  it { should treetop_parse("\t ") }
  it { should treetop_parse("\n ") }
  
  it { should treetop_parse("hi_there") }
  it { should treetop_parse("oneword") }
  it { should_not treetop_parse("_this") }
  it { should_not treetop_parse("9this") }
  
  it { should treetop_parse("unicoɷʦƞ_2") } # as an alphas_and_underscores
end
