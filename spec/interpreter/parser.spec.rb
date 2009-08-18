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

    ["instr foo_bar", "instr      foo_bar", "instr\tfoo_bar"].each do |b|
      it "should recognize #{b}" do
        @parser.parse(b).should be_a_kind_of(Treetop::Runtime::SyntaxNode)
      end
      
      it "should have an opcode 'foo_bar'" do
        @parser.parse(b).instruction_name.should == "foo_bar"
      end
    end    
    
    ["channel x", "channel\tx"].each do |b|
      it "should recognize #{b}" do
        @parser.parse(b).should be_a_kind_of(Treetop::Runtime::SyntaxNode)
      end
      
      it "should have a channel name 'x'" do
        @parser.parse(b).channel_name.should == "x"
      end
    end
    
    describe "literals:" do
      describe "integers" do
        ["literal int,8", "literal\tint , 8"].each do |b|
          it "should recognize #{b}" do
            @parser.parse(b).should be_a_kind_of(Treetop::Runtime::SyntaxNode)
          end

          it "should have a target_stack of int" do
            @parser.parse(b).stack_name.should == "int"
          end

          it "should have a value of 8" do
            @parser.parse(b).value.should == 8
          end
        end
      end
      
      describe "booleans" do
        ["literal bool,true", "literal\t bool ,false"].each do |b|
          it "should recognize #{b}" do
            @parser.parse(b).should be_a_kind_of(Treetop::Runtime::SyntaxNode)
          end

          it "should have a target_stack of bool" do
            @parser.parse(b).stack_name.should == "bool"
          end

          it "should be a boolean" do
            [FalseClass,TrueClass].should include(@parser.parse(b).value.class)
          end
        end
      end
      
    end
    
  end
end