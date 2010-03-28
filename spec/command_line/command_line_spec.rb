#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
include Nudge


describe "CliRunner" do
  it "should capture the filename in an attribute" do
    IO.stub!(:open).and_return("")
    CliRunner.new("beeboop").filename.should == "beeboop"
  end
  
  it "should create a new NudgeProgram from the raw_code" do
    IO.should_receive(:open).with("beeboop").and_return("abc")
    CliRunner.new("beeboop")
  end
  
  it "should create an Interpreter instance" do
    IO.stub!(:open).and_return("")
    Interpreter.should_receive(:new)
    CliRunner.new("beeboop")
  end
end