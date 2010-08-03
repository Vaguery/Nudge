# encoding: UTF-8
require File.expand_path("../nudge", File.dirname(__FILE__))

describe "NudgeParser" do
  describe ".new (script: String)" do
    it "stores script's tokens in @tokens" do
      parser = NudgeParser.new("ref x")
      parser.instance_variable_get(:@tokens).should == [[:ref, 0], [:ID, :x], [false, false]]
    end
    
    it "raises InvalidScript if script contains invalid tokens" do
      lambda { NudgeParser.new("ref 9") }.should raise_error NudgeError::InvalidScript,
        "script contains invalid tokens"
    end
    
    it "raises InvalidScript if script contains only footnotes" do
      lambda { NudgeParser.new("\n«int»9") }.should raise_error NudgeError::InvalidScript,
        "script contains only footnotes"
    end
  end
  
  describe "#do_parse" do
    it "returns a new NudgePoint" do
      NudgeParser.new("block {}").send(:do_parse).should be_a NudgePoint
    end
    
    it "raises InvalidScript if the token stream is syntactically incorrect" do
      lambda { NudgeParser.new("ref ref ref").send(:do_parse) }.should raise_error NudgeError::InvalidScript,
        "script tokens do not form valid Nudge program"
    end
    
    it "raises InvalidScript if the token stream describes «exec» literals" do
      lambda { NudgeParser.new("value «exec»\n«exec»1").send(:do_parse) }.should raise_error NudgeError::InvalidScript,
        "script contains «exec» literals"
    end
  end
end
