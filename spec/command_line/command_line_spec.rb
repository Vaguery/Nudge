#encoding: utf-8
require File.join(File.dirname(__FILE__), "./../spec_helper")
include Nudge


describe "CliRunner" do
  before(:each) do
    IO.stub!(:open).and_return("xyz123") # to avoid hitting the file
  end
  
  it "should capture the filename in an attribute" do
    CliRunner.new("beeboop").filename.should == "beeboop"
  end
  
  it "should create an Interpreter instance" do
    Interpreter.should_receive(:new)
    CliRunner.new("beeboop")
  end
  
  it "should capture other options it gets" do
    lambda{CliRunner.new("foo", types:["int"])}.should_not raise_error
    a = CliRunner.new("bar", types:["bool"], stepLimit: 10000)
    a.options.should == {:types=>["bool"], :stepLimit=>10000}
  end
  
  it "should pass those options down into its Interpreter instance's initialization" do
    lambda{CliRunner.new("foo", types:["int"])}.should_not raise_error
    a = CliRunner.new("bar", types:["bool"], step_limit: 10000)
    a.interpreter.stepLimit.should == 10000
    a.interpreter.types.should == ["bool"]
  end
  
  
  describe "setup" do
    before(:each) do
      IO.stub!(:open).and_return("ref g") # to avoid hitting the file
    end
    
    it "should open the file and read in the program" do
      IO.should_receive(:open).with("beebop").and_return("block {}")
      CliRunner.new("beebop").setup
    end
    
    it "should save the read filestream into #raw_code" do
      cr = CliRunner.new("beebop")
      cr.setup
      cr.raw_code.should == "ref g"
    end
    
    it "should reset the Interpreter with the new program" do
      cr = CliRunner.new("beebop")
      cr.setup
      cr.interpreter.program.should == cr.raw_code
    end
  end
  
  
  describe "run" do
    before(:each) do
      IO.stub!(:open).and_return("value «bool»\n«bool» false") # to avoid hitting the file
    end
    
    it "should run the interpreter" do
      cr = CliRunner.new("fakefile")
      cr.setup
      cr.interpreter.should_receive(:run)
      cr.run
    end
    
    it "should pass along the return value of the interpreter (the sensors' output)" do
      cr = CliRunner.new("fakefile")
      cr.setup
      cr.interpreter.register_sensor("output") {|intrprtr| 82}
      cr.run.should == {"output"=>82}
    end
  end
end