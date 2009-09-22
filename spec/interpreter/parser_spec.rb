require File.join(File.dirname(__FILE__), "/../spec_helper")

require 'pp'
include Nudge

describe "parser" do
  before(:all) do
    @parser = NudgeLanguageParser.new
  end
  
  after(:each) do
    Stack.cleanup
  end
    
  it "should fail for an empty program" do
    empty = ""
    @parser.parse(empty).should == nil
  end
  
  describe "works for single-line code" do
    it "should recognize 'block {}'" do
      just_block = fixture(:just_block)
      @parser.parse(just_block).should be_a_kind_of(BlockNode)
      asCode = @parser.parse(just_block).to_points
      asCode.should be_a_kind_of(CodeBlock)
    end
    
    it "should have the right #contents for 'block {}'" do
      just_block = fixture(:just_block)
      asCode = @parser.parse(just_block).to_points
      asCode.should be_a_kind_of(CodeBlock)
      asCode.contents.should be_a_kind_of(Array)
      asCode.contents.length.should == 0
    end
    
    it %(should recognize \"block {}\\n\") do
      extraSpace = @parser.parse(fixture(:just_block_with_newline))
      extraSpace.should be_a_kind_of(BlockNode)
      asCode = extraSpace.to_points
      asCode.should be_a_kind_of(CodeBlock)
      asCode.contents.should be_a_kind_of(Array)
      asCode.contents.length.should == 0
    end
    
    describe ": just one instruction line" do
      [fixture(:one_line_instr), "instr      foo_bar", "instr\tfoo_bar"].each do |b|
        it "should recognize \"#{b}\"" do
          @parser.parse(b).should be_a_kind_of(InstructionNode)
        end
        
        it "should return an Instruction object for \"#{b}\"" do
          asCode = @parser.parse(b).to_points
          asCode.should be_a_kind_of(InstructionPoint)
          asCode.name.should == "foo_bar"
        end
      end
    end
    
    describe ": just one channel line" do
      ["channel x", "channel\tx"].each do |b|
        it "should recognize \"#{b}\"" do
          @parser.parse(b).should be_a_kind_of(ChannelNode)
        end
      
        it "should return a Channel object for \"#{b}\"" do
          asCode = @parser.parse(b).to_points
          asCode.should be_a_kind_of(Channel)
          asCode.name.should == "x"
        end
      end
    end
    
    describe ": just one literal line" do
      
      describe "(integer literals)" do
        [["literal int,8",:int,8],
          ["literal\tint , 8",:int,8],
          ["literal int,-221",:int,-221]
          ].each do |b|
          
          it "should recognize \"#{b[0]}\"" do
            @parser.parse(b[0]).should be_a_kind_of(LiteralNode)
          end
          
          it "should return a Literal for \"#{b[0]}\"" do
            asCode = @parser.parse(b[0]).to_points
            asCode.should be_a_kind_of(Literal)
            asCode.type.should == b[1]
            asCode.value.should == b[2]
          end
        end
      end
      
      describe "(boolean literals)" do
        [["literal bool,true",:bool,true],
          ["literal\t bool ,false",:bool,false],
          ["literal bool,FALSE",:bool,false],
          ["literal bool,True",:bool,true]
          ].each do |b|
          
          it "should recognize \"#{b[0]}\"" do
            @parser.parse(b[0]).should be_a_kind_of(LiteralNode)
          end

          it "should return a Literal object for \"#{b[0]}\"" do
            asCode = @parser.parse(b[0]).to_points
            asCode.should be_a_kind_of(Literal)
            asCode.type.should == b[1]
            asCode.value.should == b[2]
          end
        end
      end

      describe "(float literals)" do
        [["literal float,-6.2",:float,-6.2],
          ["literal\t float ,1992.0001",:float,1992.0001],
          ["literal\t float , 0.00010101",:float,0.00010101],
          ["literal\t float , 2",:float,2.0]].each do |b|
            
          it "should recognize \"#{b[0]}\"" do
            @parser.parse(b[0]).should be_a_kind_of(LiteralNode)
          end
          
          it "should return a Literal object for \"#{b[0]}\"" do
            asCode = @parser.parse(b[0]).to_points
            asCode.should be_a_kind_of(Literal)
            asCode.type.should == b[1]
            asCode.value.should be_close(b[2],0.000001)
          end          
        end
      end
      
      describe "complex literals" do
        it "use some kind of reference system for complicated literals"
      end
    end
    
    
    describe ": just one ERC line" do
      describe "(integer ERCs)" do
        [["erc int,-912",:int,-912],["erc\tint , -88",:int,-88]].each do |b|
          it "should recognize \"#{b}\"" do
            @parser.parse(b[0]).should be_a_kind_of(ERCNode)
          end
          
          it "should return an Erc object for \"#{b[0]}\"" do
            asCode = @parser.parse(b[0]).to_points
            asCode.should be_a_kind_of(Erc)
            asCode.type.should == b[1]
            asCode.value.should ==b[2]
          end          
        end
      end
      
      describe "(boolean ERCs)" do
        [["erc bool,true",:bool, true],
          ["erc\t bool ,false",:bool, false]].each do |b|
          it "should recognize \"#{b[0]}\"" do
            @parser.parse(b[0]).should be_a_kind_of(ERCNode)
          end
          
          it "should return an Erc object for \"#{b[0]}\"" do
            asCode = @parser.parse(b[0]).to_points
            asCode.should be_a_kind_of(Erc)
            asCode.type.should == b[1]
            asCode.value.should ==b[2]
          end          
        end
        
        it "should ignore case" do
          @parser.parse("literal bool,FALSE").value.should == false
          @parser.parse("literal bool,True").value.should == true
        end
      end
      
      
      describe "(float ERCs)" do
        [["erc float,-9999.001",:float,-9999.001],
          ["erc\t float ,33.3",:float,33.3],
          ["erc\t\t  \tfloat , 12.12",:float,12.12],
          ["erc         float , 1000",:float,1000.0]].each do |b|
          it "should recognize \"#{b[0]}\"" do
            @parser.parse(b[0]).should be_a_kind_of(ERCNode)
          end
          
          it "should return an Erc object for \"#{b[0]}\"" do
            asCode = @parser.parse(b[0]).to_points
            asCode.should be_a_kind_of(Erc)
            asCode.type.should == b[1]
            asCode.value.should be_close(b[2],0.000001)
          end
        end
      end
      
    end
    
    describe "handling missing/unspecified value" do
      it "should work even when there's no value specified"
      it "should set the value once, until reset"
    end
  end
  
  describe "should handle long lists in blocks" do
    listy = ["block {\n  literal int,1}", "block {\n  literal int,2\n  literal int,3}"]
    listy.each do |n|
      it "should recognize \"#{n}\"" do
        @parser.parse(n).should_not == nil
      end
    end
  end
  
  describe "maintain structure for manipulation" do
    it "should fail when there are empty lines"
    it "should fail when a nonblock follows a block without a brace between"
  end
  
  
  describe "should handle two-line code" do
    b2s = ["  block {}  block {}","\tblock{}\n\tblock{}","instr hey_there\ninstr now_then"]
    b2s.each do |b|
      it "should fail to recognize \"#{b}\" because there are two root lines" do
        @parser.parse(b).should == nil
      end
    end
    
    b2s = ["block {\n channel x}"]
    b2s.each do |b|
      it "should recognize \"#{b}\"" do
         @parser.parse(b).should_not == nil
      end
      
      it "should have the right stuff inside it" do
        asCode = @parser.parse(b).to_points
        asCode.should be_a_kind_of(CodeBlock)
        asCode.contents.should be_a_kind_of(Array)
        asCode.contents[0].should be_a_kind_of(Channel)
        asCode.contents[0].name.should == "x"
      end
    end
    
    b2s = ["block {\n  block {}}"]
    b2s.each do |b|
      it "should recognize \"#{b}\"" do
         @parser.parse(b).should_not == nil
      end
      
      it "should have the right stuff inside it" do
        asCode = @parser.parse(b).to_points
        asCode.should be_a_kind_of(CodeBlock)
        asCode.contents.should be_a_kind_of(Array)
        asCode.contents[0].should be_a_kind_of(CodeBlock)
        asCode.contents[0].contents.should == []
      end
    end
    
    b2s = [["block {\n  instr hey_now}",InstructionPoint],
      ["block {\n  literal int, 22 }",Literal],
      ["block {\n  channel WVIZ}",Channel]]
    b2s.each do |b|
      it "should have the correct inner node type for \"#{b[0]}\"" do
        asCode = @parser.parse(b[0]).to_points
        asCode.should be_a_kind_of(CodeBlock)
        asCode.contents.should be_a_kind_of(Array)
        asCode.contents[0].should be_a_kind_of(b[1])
      end
    end
  end
  
  describe "it should work for long lists of one-line points in a block" do
    b2s = [["block {\n  instr A\n  instr B\n  instr C}",3],
      ["block {\n  literal int, 22\n  literal int, 23 \n  literal int, 24\n channel x\nchannel y}",5],
      ["block {\n  channel WVIZ\n  channel WAMU}",2]]
    b2s.each do |b|
      it "should have the correct inner node type for \"#{b[0]}\"" do
        asCode = @parser.parse(b[0]).to_points
        asCode.should be_a_kind_of(CodeBlock)
        asCode.contents.should be_a_kind_of(Array)
        asCode.contents.length.should == b[1]
      end
    end
  end
  
  
  describe "should handle nested blocks" do
    nesty = ["block{\n  block {\n    block {}}}","block {\n  block {}\n  block {\n    block {\n      block {}}}}"]
    nesty.each do |n|
      it "should recognize \"#{n}\"" do
        @parser.parse(n).should_not == nil
      end
    end
  end
  
  describe "should handle complex blocks" do
    nasty = ["block{\n  channel x\n  block {\n    channel y}}","block {\n  block {}\n  channel x\n  channel y}"]
    nasty.each do |n|
      it "should recognize \"#{n}\"" do
        @parser.parse(n).should_not == nil
      end
    end
  end
  
  
end