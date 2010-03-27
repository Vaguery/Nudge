#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge


describe "Code Type" do
  
  it "should have a #recognizes? method that returns true if the arg is a string" do
    CodeType.recognizes?("").should == true
    CodeType.recognizes?(NudgeProgram.new("")).should == false
    CodeType.recognizes?(992).should == false
  end
  
  
  it "should respond to #any_value by returning a string" do
    CodeType.any_value.should be_a_kind_of(String)
  end
  
  
  it "should pass along an options Hash, if passed in" do
    lambda{CodeType.any_value(target_size_in_points:2)}.should_not raise_error
    NudgeProgram.new(CodeType.any_value(target_size_in_points:2)).points.should == 2
    NudgeProgram.new(CodeType.any_value(target_size_in_points:33)).points.should == 33
    NudgeProgram.new(CodeType.any_value).points.should == 20
  end
  
  
  describe StringRewritingGenerator do
    before(:each) do
      @sg = StringRewritingGenerator.new
    end
    
    it "should store the incoming options Hash in self#incoming_options" do
      StringRewritingGenerator.new(foo:"bar", baz:123).incoming_options.should == 
        {foo:"bar", baz:123}
    end
    
    it "should have defaults for everything it needs" do
      lambda{StringRewritingGenerator.new()}.should_not raise_error
    end
    
    it "should accept options Hash argument" do
      lambda{StringRewritingGenerator.new(options = {hi:"there"})}.should_not raise_error
    end
    
    it "should capture options[:target_size_in_points]" do
      StringRewritingGenerator.new(target_size_in_points:7).target_size_in_points.should == 7
    end
    
    it "should have a default target_size_in_points set to 20" do
      StringRewritingGenerator.new.target_size_in_points.should == 20
    end
    
    it "should generate a String when #generate is called" do
      StringRewritingGenerator.new.generate.should be_a_kind_of(String)
    end
    
    it "should have a default self#probabilities set to [1,1,1,1]" do
      @sg.probabilities.should == {b:1, r:1, v:1, i:1}
    end
    
    it "should capture options[:probabilities] into self#probabilities" do
      biased = StringRewritingGenerator.new(:probabilities => {b:3, r:97, v:0, i:0})
      biased.probabilities.should == {b:3, r:97, v:0, i:0}
    end
    
    it "should raise an exception if the :probabilities hash doesn't have exactly the keys [b,r,v,i]" do
      lambda{StringRewritingGenerator.new(:probabilities => {b:1, r:1, v:0, i:0})}.should_not raise_error
      lambda{StringRewritingGenerator.new(:probabilities => {b:1})}.should raise_error(ArgumentError)
      lambda{StringRewritingGenerator.new(:probabilities => {})}.should raise_error(ArgumentError)
      lambda{StringRewritingGenerator.new(:probabilities => {b:1, r:1, v:0, i:0, q:9999})}.should
        raise_error(ArgumentError)
    end
    
    it "should raise an exception if there are no positive values in the probabilities table" do
      lambda{StringRewritingGenerator.new(:probabilities => {b:0, r:0, v:0, i:0})}.should raise_error
      lambda{StringRewritingGenerator.new(:probabilities => {b:-2, r:-8, v:1, i:9})}.should raise_error
    end
    
    it "should capture an Array in options[:reference_names] into self#reference_names" do
      lambda{StringRewritingGenerator.new(reference_names:["a"])}.should_not raise_error
      StringRewritingGenerator.new(reference_names:["b"]).reference_names.should == ["b"]
    end
    
    it "should capture an Array in options[:type_names] into self#type_names" do
      lambda{StringRewritingGenerator.new(type_names:["int"])}.should_not raise_error
      StringRewritingGenerator.new(type_names:["code"]).type_names.should == ["code"]
    end
    
    it "should default #type_names to NudgeType::all_types" do
      @sg.type_names.should == NudgeType::all_types.collect {|t| t.to_nudgecode.to_s}
    end
    
    it "should capture an Array in options[:instruction_names] into self#instruction_names" do
      lambda{StringRewritingGenerator.new(instruction_names:["int_add"])}.should_not raise_error
      StringRewritingGenerator.new(instruction_names:["code_dup"]).instruction_names.should == ["code_dup"]
    end
    
    it "should default #instruction_names to Instruction.all_instructions" do
      @sg.instruction_names.should == Instruction.all_instructions.collect {|i| i.to_nudgecode.to_s} 
    end
    
    it "should return an empty string if :target_size_in_points => 0" do
      StringRewritingGenerator.new(target_size_in_points:0).generate.should == ""
    end
    
    it "should use #backbone to build a framework string of the right size" do
      @sg.backbone.should == "*"* 20
      StringRewritingGenerator.new(target_size_in_points:8).backbone.should == "********"
    end
    
    it "should use #open_framework to fill in 'b', 'i', 'v' and 'r' in all positions" do
      @sg.open_framework.should be_a_kind_of(String)
      @sg.open_framework.match(/[^bivr]/).should == nil
    end
    
    it "should place a 'b' at the front of the open_framework if points > 1" do
      blockless = StringRewritingGenerator.new(probabilities:{b:0,i:2,v:0,r:0}, target_size_in_points:7)
      blockless.open_framework.should == "biiiiii"
    end
    
    it "should use #open_framework to produce the defined proportions of letters" do
      vr_only = StringRewritingGenerator.new(probabilities:{b:0,i:0,v:100,r:10}, target_size_in_points:1000)
      one_possible_framework = vr_only.open_framework
      vs = one_possible_framework.count "v"
      rs = one_possible_framework.count "r"
      bs = one_possible_framework.count "b"
      bs.should == 1
      (vs/rs).should > 1
    end
    
    it "should use #closed_framework to fill in a final brace" do
      @sg.closed_framework("i").should == "i"
      @sg.closed_framework("v").should == "v"
      @sg.closed_framework("r").should == "r"
      @sg.closed_framework("b").should == "b{}"
      @sg.closed_framework("biiii").should == "b{iiii}"
      @sg.closed_framework("birvriviiriv").should == "b{irvriviiriv}"
    end
    
    it "should use #closed_framework to fill in internal braces" do
      long = @sg.closed_framework("b"*100)
      long.count('{').should == long.count('}')
      long.index('}{').should == nil
      long.index('b}').should == nil
    end
    
    describe "filling in the program point statements with #filled_framework" do
      it "should return a Hash of two new strings, with keys :code_part and :footnote_part" do
        @sg.filled_framework.should be_a_kind_of(Hash)
        @sg.filled_framework.length.should == 2
        @sg.filled_framework.keys.should == [:code_part, :footnote_part]
        @sg.filled_framework.values.each {|v| v.should be_a_kind_of(String)}
      end
      
      it "should replace all the 'b' characters with the string 'block ' in the :code_part" do
        @sg.filled_framework('b{}')[:code_part].should == 'block {}'
        @sg.filled_framework('b{b{}b{b{}}}')[:code_part].should == 'block {block {}block {block {}}}' 
      end
            
      it "should replace all the 'i' characters with the string 'do [inst_name]' in the :code_part" do
        one_choice = StringRewritingGenerator.new(instruction_names:["foo"])
        one_choice.filled_framework('i')[:code_part].should == 'do foo'
        one_choice.filled_framework('b{i}')[:code_part].should include('{do foo')
        one_choice.filled_framework('b{ii}')[:code_part].should include("do foo do foo")
      end
      
      it "should sample the instruction_names randomly" do
        two_choices = StringRewritingGenerator.new(instruction_names:["foo", "bar"])
        two_choices.instruction_names.should_receive(:sample).exactly(2).times.
          and_return(["foo", "bar"].sample)
        two_choices.filled_framework('b{ii}')[:code_part]
      end
      
      it "should replace all the 'r' characters with the string 'ref [ref_name]' in the :code_part" do
        one_choice = StringRewritingGenerator.new(reference_names:["x1"])
        one_choice.filled_framework('r')[:code_part].should == 'ref x1'
        one_choice.filled_framework('b{r}')[:code_part].should == 'block {ref x1 }'
        one_choice.filled_framework('b{rr}')[:code_part].should == "block {ref x1 ref x1 }"
      end
      
      it "should sample the reference_names randomly" do
        two_choices = StringRewritingGenerator.new(reference_names:["x", "y"])
        two_choices.reference_names.should_receive(:sample).exactly(2).times.
          and_return("x","y")
        two_choices.filled_framework('b{rr}')[:code_part].should == "block {ref x ref y }"
      end
      
      it "should generate a novel (and non-conflicting) ref_name if there are none defined" do
        no_choices = StringRewritingGenerator.new
        no_choices.filled_framework('r')[:code_part].should == "ref aaa001"
        no_choices.filled_framework('r')[:code_part].should == "ref aaa002"
        no_choices.filled_framework('b{rr}')[:code_part].should == "block {ref aaa003 ref aaa004 }"
      end
      
      it "should replace all the 'v' characters with the string 'value «[ref_name]»' in the :code_part" do
        one_choice = StringRewritingGenerator.new(type_names:["int"])
        one_choice.filled_framework('v')[:code_part].should == 'value «int»'
        one_choice.filled_framework('b{v}')[:code_part].should == 'block {value «int» }'
        one_choice.filled_framework('b{vv}')[:code_part].should == "block {value «int» value «int» }"
      end
      
      it "should sample the type_names randomly" do
        two_choices = StringRewritingGenerator.new(type_names:["foo", "bar"])
        two_choices.type_names.should_receive(:sample).exactly(2).times.
          and_return("foo","bar")
        two_choices.filled_framework('b{vv}')[:code_part].should == "block {value «foo» value «bar» }"
      end
      
      it "should generate a footnote even if there is no class defined for the type" do
        no_choices = StringRewritingGenerator.new(type_names:[])
        no_choices.filled_framework('v')[:code_part].should == "value «unknown»"
        no_choices.filled_framework('v')[:footnote_part].should == "«unknown»"
        
        two_choices = StringRewritingGenerator.new(type_names:["baz", "qux"])
        two_choices.type_names.should_receive(:sample).exactly(2).times.
          and_return("baz","qux")
        two_choices.filled_framework('b{vv}')[:footnote_part].should == "«baz» \n«qux»"
      end
      
      it "should generate a footnote if there is a defined random_value method for that type" do
        one_choice = StringRewritingGenerator.new(type_names:["int"])
        IntType.should_receive(:any_value).and_return(129)
        one_choice.filled_framework('v')[:footnote_part].should == "«int» 129"
        
        one_choice = StringRewritingGenerator.new(type_names:["bool"])
        BoolType.should_receive(:any_value).and_return(false)
        one_choice.filled_framework('v')[:footnote_part].should == "«bool» false"
        
        one_choice = StringRewritingGenerator.new(type_names:["float"])
        FloatType.should_receive(:any_value).and_return(0.1234)
        one_choice.filled_framework('v')[:footnote_part].should == "«float» 0.1234"
      end
      
      describe "should work for :code values as well!" do
        it "should use the CodeType.any_value call" do
          one_scary_choice = StringRewritingGenerator.new(type_names:["code"])
          CodeType.should_receive(:any_value).and_return("block {}")
          one_scary_choice.filled_framework('v')[:footnote_part].should == "«code» block {}"          
        end
        
        
        it "should reduce the :target_size_in_points in every recursive call" do
          one_scary_choice = StringRewritingGenerator.new(type_names:["code"], target_size_in_points:8)
          CodeType.should_receive(:any_value).with(hash_not_including(:target_size_in_points => 8))
          one_scary_choice.filled_framework('v')
          # this could be more accurate; at present it just checks the value changes
          # writing the rspec matcher for the actual test would be better
        end
        
        it "should add footnotes at the end of :footnote_part in the order they're added in code" do
          three_types = StringRewritingGenerator.new(type_names:["int", "bool", "float"])
          diceroll = three_types.filled_framework('b{vvvvvvvvv}')
          diceroll[:code_part].scan(/«(...|....)»/).should ==
            diceroll[:footnote_part].scan(/«(...|....)»/)
        end
        
        it "should generate any needed sub-footnote values from within other footnote values" do
          nestable = StringRewritingGenerator.new(
            type_names:["int", "code"], probabilities:{b:0,v:10,r:0,i:0})
          # test this by generating a pile of nested footnotes and cycling them through the parser
          diceroll = nestable.filled_framework('b{vvvvvvvvvvvvv}')
          as_nudge = NudgeProgram.new("#{diceroll[:code_part]}\n#{diceroll[:footnote_part]}")
          cycled = as_nudge.blueprint
          cycled.scan(/«(...|....)»/).should ==
            (diceroll[:code_part]+diceroll[:footnote_part]).scan(/«(...|....)»/)
        end      
      end
    end
    
    
    it "should have a expected number of points" do
      stubby = StringRewritingGenerator.new(target_size_in_points:1)
      frilly = StringRewritingGenerator.new(target_size_in_points:100, probabilities:{b:10,i:1,v:0,r:0})
      rambly = StringRewritingGenerator.new(target_size_in_points:20, probabilities:{b:0,i:0,v:1,r:0},
        type_names:["code","int"])
      
      
      NudgeProgram.new(stubby.generate).points.should == 1
      NudgeProgram.new(frilly.generate).points.should == 100
      NudgeProgram.new(rambly.generate).points.should == 20
    end
    
  end

end