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
    a = CliRunner.new("bar", types:["bool"], step_limit: 10000)
    a.options.should == {:types=>["bool"], :step_limit=>10000}
  end
  
  it "should pass those options down into its Interpreter instance's initialization" do
    lambda{CliRunner.new("foo", types:["int"])}.should_not raise_error
    a = CliRunner.new("bar", types:["bool"], step_limit: 10000)
    a.interpreter.step_limit.should == 10000
    a.interpreter.types.should == ["bool"]
  end
  
  
  describe "setup" do
    before(:each) do
      IO.stub!(:open).and_return("ref g") # to avoid hitting the file
      @cr = CliRunner.new("beebop")
    end
    
    it "should open the file and read in the program" do
      IO.should_receive(:open).with("beebop").and_return("block {}")
      CliRunner.new("beebop").setup
    end
    
    it "should save the read filestream into #raw_code" do
      @cr.setup
      @cr.raw_code.should == "ref g"
    end
    
    it "should reset the Interpreter with the new program" do
      @cr.setup
      @cr.interpreter.program.should == @cr.raw_code
    end
    
    it "should be able to accept an optional Hash of variable bindings" do
      lambda{@cr.setup(variables:{"x" => ValuePoint.new("int", 9)})}.should_not raise_error
    end
    
    it "should build those bindings into its interpreter" do
      @cr.setup(variables:{"x" => ValuePoint.new("int",1002)})
      @cr.interpreter.variables["x"].value.should == 1002
    end
    
    it "should be able to accept an optional Hash of sensor definitions" do
      lambda{@cr.setup(sensors:{"x" => Proc.new {|me| "hi there"}} )}.should_not raise_error
    end
    
    it "should register those sensors in the interpreter" do
      @cr.setup(sensors:{"x" => Proc.new {|me| "hi there"}})
      @cr.interpreter.sensors["x"].call.should == "hi there"
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


describe CliParser do
  describe "filename" do
    it "should read the filename from ARGV"
  end
  
  describe "step_limit" do
    it "should be an optional parameter"
    
    it "should parse the step_limit from ARGV"
  end
  
  describe "types" do
    it "should be an optional parameter"
    
    it "should parse the type_names from ARGV"
  end
  
  describe "instructions" do
    it "should be an optional parameter"
    
    it "should parse the instruction_names from ARGV"
  end
  
  describe "variable bindings" do
    it "should be an optional parameter"
    
    it "should parse the variable bindings from ARGV"
  end
  
  describe "sensors" do
    it "should be an optional parameter"
    
    it "should parse the sensor definitions from ARGV"
  end
end
