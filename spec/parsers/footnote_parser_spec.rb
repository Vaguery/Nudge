#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
load_grammar('footnote')
include Nudge

describe NudgeFootnoteParser do
  before(:each) do
    @parser = NudgeFootnoteParser.new()
  end
  
  it { should parse('«1» this is a simple string' ) }
  it { should parse('«2» this is\n multiline string' ) }
  it { should parse('«3»    this is a string with leading spaces' ) }
  it { should parse("«4»  \tthis is a string with leading tabs" ) }
  it { should parse("«5»  \n\n this is a string with leading newlines and spaces" ) }
  
  it "should not capture leading space" do
    got = @parser.parse("«6»   \t\n \n\t 123").elements[2].text_value
    got.should == "123"
  end
  
  it "should capture trailing space" do
    got = @parser.parse("«6» 123\n\n\n").elements[2].text_value
    got.should == "123\n\n\n"
  end
  
  
  it "should get the body right if it's multiline" do
    got = @parser.parse("«7»\t \n this is\n 3-line string\n!").elements[2].text_value
    got.should == "this is\n 3-line string\n!"
    got.split(/\n/).length.should == 3
  end
  
  it "shouldn't care if there are more footnote markup chars in the body" do
    tricky = "including « loose « and matching «3» ones"
    got = @parser.parse("«8» #{tricky}").elements[2].text_value
    got.should == tricky
  end
end
