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
        NudgeTree.from(exp)[:tree].should_not == nil
    end
  end
  
  it "should return the right ProgramPoint class for InstructionPoints" do
    ["do int_add",
      "do foo_bar",
      "do x_1"].each do |exp|
      NudgeTree.from(exp)[:tree].should be_a_kind_of(InstructionPoint)
    end
  end
    
  it "should return the right ProgramPoint class for ReferencePoints" do
    ["ref x88",
      "ref a_1"].each do |exp|
      NudgeTree.from(exp)[:tree].should be_a_kind_of(ReferencePoint)
    end
  end
  
  it "should return the right ProgramPoint class for ValuePoints" do
    ["value «x»" ,
      "value «x_1»" ,
      "value «xyz»" ,
      "value «my_type»",
      "value «x»\n«x» 8" ,
      "value «x_1»\n«x_1» 9" ,
      "value «xyz»\n«xyz» 10" ,
      "value «my_type»\n«my_type» 11"].each do |exp|
        NudgeTree.from(exp)[:tree].should be_a_kind_of(ValuePoint)
    end
    
  end
  
  
  it "should return the right ProgramPoint class for CodeblockPoints" do
    ["block {}" ,
      "block {\t}" ,
      "block {\n }" ,
      "block { block { block {block{block{}}}} }",
      "block {do int_add}" ,
      "block{do int_add}" ,
      "block{do int_add\ndo int_add value «foo»}\n«foo» baz"].each do |exp|
        NudgeTree.from(exp)[:tree].should be_a_kind_of(CodeblockPoint)
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
        NudgeTree.from(junk)[:tree].should be_a_kind_of(NilPoint)
    end
  end
  
  
  
  it "should be happy with unicode" do
    ["value «a_éüîøö»",
      "do β_assay",
      "ref Ünt_ADD",
      "block {value «β_distribution»}"].each do |exp|
      NudgeTree.from(exp)[:tree].should_not be_a_kind_of(NilPoint)
    end
  end
  
  it "should be happy with extra spaces" do
    ["\tvalue \n\t«int»" ,
      "do \n      int_add" ,
      "ref \nx88\n" ,
      "block {\t}" ,
      "block \n{\t}" ,
      "block   {\n }\n"].each do |exp|
        NudgeTree.from(exp)[:tree].should_not be_a_kind_of(NilPoint)
    end
  end
  
  
  it "should parse well-formed footnotes" do
    NudgeTree.from("value «code»\n«int» 9\n«code» value «int»")[:tree].should_not be_a_kind_of(NilPoint)
    nt = NudgeTree.from("value «code»\n«int» 9\n«code» value «int»")
    nt[:tree].should be_a_kind_of(ValuePoint)
    nt[:tree].blueprint.should == "value «code» \n«code» value «int»\n«int» 9"
  end
  
  
  it "should work with multi-line footnotes" do
    wordy = "value «code»\n«code» block {\ndo thing_1\n  do thing_2}\n«int» 5"
    lambda{NudgeTree.from(wordy)}.should_not raise_error
    NudgeTree.from(wordy)[:tree].blueprint.should == 
      "value «code» \n«code» block {\ndo thing_1\n  do thing_2}"
  end
  
  
  it "should parse code with malformed footnotes (but they'll turn out weird)" do
    busted = "value «code» \n«code» do thing\n«float 2» 9"
    NudgeTree.from(busted).should_not be_a_kind_of(NilPoint)
    NudgeTree.from(busted)[:tree].blueprint.should == "value «code» \n«code» do thing"
    
    strange = "value «code» \n«float 2» 9\n«code» do thing\n"
    NudgeTree.from(strange).should_not be_a_kind_of(NilPoint)
    NudgeTree.from(strange)[:tree].blueprint.should == "value «code» \n«code» do thing"
  end
  
  
  it "should parse code with missing footnote values" do
    lacuna = "value «code» \n«code»"
    NudgeTree.from(lacuna).should_not be_a_kind_of(NilPoint)
    NudgeTree.from(lacuna)[:tree].blueprint.should == "value «code» \n«code»"
    
    lacuna = "block {value «code» value «code» value «int»} \n«code» do a\n«code» \n«int» 77"
    NudgeTree.from(lacuna).should_not be_a_kind_of(NilPoint)
    NudgeTree.from(lacuna)[:tree].blueprint.should ==
      "block {\n  value «code»\n  value «code»\n  value «int»} \n«code» do a\n«code»\n«int» 77"
  end
  
  it "should work for code missing footnotes entirely" do
    troubl = "block {value «code»}"
    lambda{NudgeTree.from(troubl)}.should_not raise_error
    NudgeTree.from(troubl)[:tree].blueprint.should == "block {\n  value «code»} \n«code»"
  end
  
  
  it "should strip whitespace off the front and back of footnote values" do
    spacey = "value «code»\n«code»  \t\t  value «float»  \t\t\n«float»  \t\n1.234"
    NudgeTree.from(spacey)[:tree].blueprint.should ==
      "value «code» \n«code» value «float»\n«float» 1.234"
  end
  
  
  it "should work for well-formed programs with insufficient footnotes by creating placeholders" do
    lacuna = "block {value «code» \nvalue «code» \nvalue «foo»}\n«code» value «foo»\n«code» block {value «code»}\n«foo» 1"
    NudgeTree.from(lacuna).should_not be_a_kind_of(NilPoint)
    NudgeTree.from(lacuna)[:tree].blueprint.should ==
      "block {\n  value «code»\n  value «code»\n  value «foo»} \n«code» value «foo»\n«foo» 1\n«code» block {value «code»}\n«code»\n«foo»"
  end
  
  
  it "should not parse a footnotes-only string" do
    NudgeTree.from("\n«int» 9\n«code» value «int»")[:tree].should be_a_kind_of(NilPoint)
    NudgeTree.from("«int» 9\n«code» value «int»")[:tree].should be_a_kind_of(NilPoint)
  end
  
  
  it "should return extra footnotes" do
    hash = NudgeTree.from("do unrelated\n«int» 9\n«code» value «int»")
    hash[:tree].blueprint.should == "do unrelated"
    hash[:unused].should == {"int"=>["9"], "code"=>["value «int»"]}
  end  
end