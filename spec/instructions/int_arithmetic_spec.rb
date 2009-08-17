require File.join(File.dirname(__FILE__), "/../spec_helper")

include Nudge
include Instructions

shared_examples_for "any Instruction" do
  it "should be a subclass of Instruction" do
    @fxn.should be_a_kind_of(Instruction)
  end
end


describe "int_add" do
  it_should_behave_like "any Instruction"

  before(:each) do
    @fxn = Int_Arithmetic::Int_add.new
  end
  
  it "should require 2 :int items" do
    @fxn.requirements.keys.should == [:int]
    @fxn.requirements[:int].should == 2
  end
  
  it "should have an effect of 1 :int item" do
    @fxn.effects.keys.should == [:int]
    @fxn.effects[:int].should == 1
  end
  
  
  describe "running" do
    before(:each) do
      @nudge = Interpreter.new
      @nudge.stacks[:int] = Stack.new(:int)
      @fxn = Int_Arithmetic::Int_add.new(@nudge)  #### REMOVE THIS
    end
    
    it "should be #ready? when there are enough arguments in the stack" do
      @nudge.stacks[:int].stub!(:depth).and_return(12)
      @fxn.ready?.should == true
    end
    
    it "should not be #ready? when there aren't enough arguments in the stacks" do
      @nudge.stacks[:int].stub!(:depth).and_return(0)
      @fxn.ready?.should == false
    end
    
    
    
    it "should emit a Literal with value = the sum of the inputs" do
      lit1 = Literal.new(:int, 12)
      @nudge.stacks[:int].stub!(:depth).and_return(100)
      @nudge.stacks[:int].stub!(:pop).and_return(lit1)
      @nudge.stacks[:int].stub!(:push)
      snag = @fxn.run
      snag.value.should == 24
    end
    
    it "should leave stacks untouched and increment NOOPs if there aren't enough inputs" do
      @nudge.stacks[:int].stub!(:depth).and_return(0)
      @nudge.NOOPs = 91
      snag = @fxn.run
      
      snag.should == "NOOP"
      @nudge.NOOPs.should == 92
    end
  end
end



describe "int_subtract" do
  it_should_behave_like "any Instruction"
  
  before(:each) do
    @fxn = Int_Arithmetic::Int_subtract.new
  end
  
  it "should require 2 :int items" do
    @fxn.requirements.keys.should == [:int]
    @fxn.requirements[:int].should == 2
  end
  
  it "should have an effect of 1 :int item" do
    @fxn.effects.keys.should == [:int]
    @fxn.effects[:int].should == 1
  end
    
  describe "running" do
  
    before(:each) do
      @nudge = Interpreter.new
      @nudge.stacks[:int] = Stack.new(:int)
      @fxn = Int_Arithmetic::Int_subtract.new(@nudge)
    end
    
    it "should be #ready? when there are enough arguments in the stacks" do
      @nudge.stacks[:int].stub!(:depth).and_return(12)
      @fxn.ready?.should == true
    end
    
    it "should not be #ready? when there aren't enough arguments in the stacks" do
      @nudge.stacks[:int].stub!(:depth).and_return(0)
      @fxn.ready?.should == false
    end
    
    it "should leave stacks untouched and increment NOOPs if there aren't enough inputs" do
      @nudge.stacks[:int].stub!(:depth).and_return(0)
      @nudge.NOOPs = 91
      snag = @fxn.run
      
      snag.should == "NOOP"
      @nudge.NOOPs.should == 92
    end
    
    it "should emit a Literal with value = the difference between the second and first popped items " do
      # code would be [8, 3, int_sub]
      lit1 = Literal.new(:int, 8)
      lit2 = Literal.new(:int, 3)
      @nudge.stacks[:int].stub!(:depth).and_return(100)
      @nudge.stacks[:int].stub!(:pop).and_return(lit2, lit1)
      @nudge.stacks[:int].stub!(:push)
      snag = @fxn.run
      snag.value.should == 5
    end
  end
end
