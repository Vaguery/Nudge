require File.join(File.dirname(__FILE__), "/../spec_helper")

require 'pp'

describe "parser" do
  before(:each) do
    @parser = NudgeLanguageParser.new
  end
  
  it "should fail for an empty listing" do
    empty = ""
    @parser.parse(empty).should == nil
  end
  
  describe "should handle single-line code" do
    it "should recognize 'block {}'" do
      just_block = fixture(:just_block)
      @parser.parse(just_block).should be_a_kind_of(BlockNode)      
    end
    
    it %(should recognize \"block \\n\") do
      @parser.parse(fixture(:just_block_with_newline)).should be_a_kind_of(BlockNode)      
    end

    [fixture(:one_line_instr), "instr      foo_bar", "instr\tfoo_bar"].each do |b|
      it "should recognize \"#{b}\"" do
        @parser.parse(b).should be_a_kind_of(InstructionNode)        
      end
      
      it "should have an opcode 'foo_bar'" do
        @parser.parse(b).instruction_name.should == "foo_bar"
      end
    end    
    
    ["channel x", "channel\tx"].each do |b|
      it "should recognize \"#{b}\"" do
        @parser.parse(b).should be_a_kind_of(ChannelNode)
      end
      
      it "should have a channel name 'x'" do
        @parser.parse(b).channel_name.should == "x"
      end
    end
    
    describe "literals:" do
      describe "integers" do
        ["literal int,8", "literal\tint , 8"].each do |b|
          it "should recognize \"#{b}\"" do
            @parser.parse(b).should be_a_kind_of(LiteralNode)
          end

          it "should have a target_stack of int" do
            @parser.parse(b).stack_name.should == "int"
            
          end

          it "should have a value of 8" do
            @parser.parse(b).value.should == 8
          end
        end
        
        it "should work for negatives" do
          neg_thing = "literal int,-221"
          @parser.parse(neg_thing).should be_a_kind_of(LiteralNode)
          @parser.parse(neg_thing).value.should == -221
          
        end
        
        it "should raise an exception if the value isn't an integer"
        
      end
      
      describe "booleans" do
        ["literal bool,true", "literal\t bool ,false"].each do |b|
          it "should recognize \"#{b}\"" do
            @parser.parse(b).should be_a_kind_of(LiteralNode)
          end

          it "should have a target_stack of bool" do
            @parser.parse(b).stack_name.should == "bool"
          end

          it "should be a boolean" do
            [FalseClass,TrueClass].should include(@parser.parse(b).value.class)
          end
          
          it "should ignore case" 
          
          it "should raise an exception if the value isn't a boolean"
        end
      end
      
      describe "floats" do
        it "should work for floats"
      end
      
      describe "complex literals" do
        it "use some kind of reference system for complicated literals"
      end
      
    end
    
  end
  
  describe "should handle two-line code" do
    b2s = ["  block {}  block {}","\tblock{}\n\tblock{}","instr hey_there\ninstr now_then"]
    b2s.each do |b|
      it "should fail to recognize \"#{b}\" because there are two root lines" do
        @parser.parse(b).should == nil
      end
    end
      
    b2s = ["block {\n  block {}}","block {\n\tblock { }  }"]
    b2s.each do |b|
      it "should recognize \"#{b}\""
      
      it %(should return two nested block elements for "#{b}")
      
      it "should create a #contents attribute for each containing the right stuff"
    end
    
    b2s = ["block\n  instr hey_now","block\n  literal int, 22", "block\n  channel WVIZ"]
    b2inners = [InstructionNode, LiteralNode, ChannelNode]
    
    b2s.each do |b|
      it "should have the corrent inner node type for \"#{b}\""
    end
  end
end