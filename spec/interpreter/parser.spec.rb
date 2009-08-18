require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "parser" do
  before(:each) do
    @parser = NudgeLanguageParser.new
  end
  
  it "should fail for an empty listing" do
    empty = ""
    @parser.parse(empty).should == nil
  end
  
  describe "should handle single-line code" do
    it "should recognize 'block'" do
      just_block = "block"
      @parser.parse(just_block).should be_a_kind_of(Treetop::Runtime::SyntaxNode)      
    end

    ["instr : foo_bar", "instr: foo_bar", "instr :foo_bar"].each do |b|
      it "should recognize #{b}" do
        @parser.parse(b).should be_a_kind_of(Treetop::Runtime::SyntaxNode)
      end
      it "should have an attribute that is #{b}" do
        @parser.parse(b).instruction_name.should == "foo_bar"
      end
    end    
    
  end
end