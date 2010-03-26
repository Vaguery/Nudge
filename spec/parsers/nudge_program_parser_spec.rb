#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
include Nudge

describe "Nudge Program parser" do
  
  it "should parse all these simple examples" do
    ["value «int»" ,
      "do int_add" ,
      "ref x88" ,
      "block {}" ,
      "block {\t}" ,
      "block {\n }" ,
      "block { block { block {block{block{}}}} }",
      "block {do int_add}" ,
      "block{do int_add}" ,
      "block{do int_add\ndo int_add value «foo»}"].each do |exp|
        lambda{NudgeTree.from(exp)}.should_not raise_error
    end
  end
  
  it "should not parse these examples" do
    ["value int (1)\ndo int_add",
      " ",
      "block",
      "do _this",
      "oneword",
      "9this",
      "do 9this",
      "do is_real?",                  # actually, I may want this one
      "do this_not_real!",            # actually, I may want this one
      "ref 1x1",
      "ref 1 x 1"].each do |junk|
      lambda{NudgeTree.from(junk)}.should raise_error(ParseError)
    end
  end
  
  it "should be happy with unicode" do
    pending "Somebody has to edit the parse.y file so this works, I think"
    ["value «a_∫»",
      "do β_assay",
      "do Int_ADD",
      "value  \n  «β_distribution»\n«β_distribution» [something here]"].each do |exp|
      lambda{NudgeTree.from(exp)}.should_not raise_error
    end
  end
  
  it "should be happy with extra spaces" do
    ["\tvalue \n\t«int»" ,
      "do \n      int_add" ,
      "ref \nx88\n" ,
      "block {\t}" ,
      "block \n{\t}" ,
      "block   {\n }\n"].each do |exp|
        lambda{NudgeTree.from(exp)}.should_not raise_error
    end
  end
  
  it "should parse well-formed footnotes" do
    lambda{NudgeTree.from("value «code»\n«int» 9\n«code» value «int»")}.should_not raise_error
    NudgeTree.from("value «code»\n«int» 9\n«code» value «int»")[:tree].should be_a_kind_of(ValuePoint)
  end
  
  it "should work with multi-line footnotes" do
    pending "Need to adjust StringScanner end-of-footnote code, I think"
    lambda{NudgeTree.from("value «code»\n«code» block {\ndo thing_1\n  do thing_2}")}.should_not raise_error
  end

  it "should not parse code with malformed footnotes" do
    lambda{NudgeTree.from("value «code» «int extra» 9\n«code» value «int»")}.should raise_error(ParseError)
  end
  
  it "should strip whitespace off footnote values"
  
  it "should not parse a footnotes-only string" do
    lambda{NudgeTree.from("\n«int» 9\n«code» value «int»")}.should raise_error(ParseError)
    lambda{NudgeTree.from("«int» 9\n«code» value «int»")}.should raise_error(ParseError)
  end
  
  it "should return extra footnotes" do
    hash = NudgeTree.from("do unrelated\n«int» 9\n«code» value «int»")
    hash[:tree].listing.should == "do unrelated"
    hash[:unused].should == {"int"=>["9"], "code"=>["value «int»"]}
  end
  
end
