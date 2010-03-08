#encoding: utf-8
require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

theseInstructions = [
  IntFromBoolInstruction,
  BoolFromIntInstruction,
  IntFromFloatInstruction,
  FloatFromIntInstruction,
  FloatFromBoolInstruction,
  BoolFromFloatInstruction,
  CodeFromFloatInstruction,
  CodeFromIntInstruction,
  CodeFromBoolInstruction
]

itNeeds = {
  IntFromBoolInstruction => {"stack" => :bool, "stackname" => "bool", "becomes" => :int},
  IntFromFloatInstruction => {"stack" => :float, "stackname" => "float", "becomes" => :int},
  BoolFromIntInstruction => {"stack" => :int, "stackname" => "int", "becomes" => :bool},
  BoolFromFloatInstruction => {"stack" => :float, "stackname" => "float", "becomes" => :bool},
  FloatFromIntInstruction => {"stack" => :int, "stackname" => "int", "becomes" => :float},
  FloatFromBoolInstruction => {"stack" => :bool, "stackname" => "bool", "becomes" => :float},
  CodeFromFloatInstruction => {"stack" => :float, "stackname" => "float", "becomes" => :code},
  CodeFromIntInstruction => {"stack" => :int, "stackname" => "int", "becomes" => :code},
  CodeFromBoolInstruction => {"stack" => :bool, "stackname" => "bool", "becomes" => :code}}
  
whatHappens = {
  IntFromBoolInstruction => {false => 0, true => 1},
  IntFromFloatInstruction => {1.1 => 1, -31.71 => -31},
  BoolFromIntInstruction => {0 => false, -2 => true, 122 => true},
  BoolFromFloatInstruction => {0.0 => false, -2.2 => true, 122.2 => true},
  FloatFromIntInstruction => {0 => 0.0, -2 => -2.0, 99 => 99.0},
  FloatFromBoolInstruction => {false => 0.0, true => 1.0},
  CodeFromFloatInstruction => {1.3 => "value «float»\n«float» 1.3", -2.8 => "value «float»\n«float» -2.8"},
  CodeFromIntInstruction => {1882 => "value «int»\n«int» 1882", -9111 => "value «int»\n«int» -9111"},
  CodeFromBoolInstruction => {false => "value «bool»\n«bool» false", true => "value «bool»\n«bool» true"}}


theseInstructions.each do |instName|
  describe instName do
    before(:each) do
      @context = Interpreter.new
      @i1 = instName.new(@context)
    end
    
    it "should have the right context" do
      @i1.context.should == @context
    end
    
    [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
      it "should respond to \##{methodName}" do
        @i1 = instName.new(@context)
        @i1.should respond_to(methodName)
      end   
    end
    
    describe "\#go" do
      before(:each) do
        @i1 = instName.new(@context)
        @context.clear_stacks
        @stackSymbol = itNeeds[instName]["stack"]
        @stackName = itNeeds[instName]["stackname"]
        @someValue = "anything_at_all"
        @it_becomes = itNeeds[instName]["becomes"]
        @myStarter = ValuePoint.new(@stackName,@someValue)
      end
      
      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          @context.stacks[@stackSymbol].push(@myStarter)
          @i1.preconditions?.should == true
        end
        
        it "should raise an error if the preconditions aren't met" do
          @context.clear_stacks # there are no params at all
          lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
        end
        
        it "should successfully run #go only if all preconditions are met" do
          @context.stacks[@stackSymbol].push(@myStarter)
          @i1.should_receive(:cleanup)
          @i1.go
        end
        
        describe "\#cleanup" do
          describe "should create and push the new (expected) value to the right place" do
            before(:each) do
              @context.clear_stacks
            end
            whatHappens[instName].each do |k,v|
              it "\'#{k}\' becomes #{itNeeds[instName]["becomes"]} \'#{v}\'" do
                @context.stacks[@stackSymbol].push(ValuePoint.new(@stackName,k))
                @i1.go
                @context.stacks[@it_becomes].peek.value.should == v
              end
            end
          end
        end
      end
    end
  end
end


describe CodeFromNameInstruction do # needs unique specs because it's manipulating ReferencePoints
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeFromNameInstruction.new(@context)
    @context.clear_stacks
  end
  
  it "should check that there are enough parameters" do
    @context.stacks[:name].push(ReferencePoint.new("foo"))
    @i1.preconditions?.should == true
  end
  
  it "should raise an error if the preconditions aren't met" do
    @context.clear_stacks # there are no params at all
    lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
  end
  
  it "should successfully run #go only if all preconditions are met" do
    @context.stacks[:name].push(ReferencePoint.new("foo"))
    @i1.should_receive(:cleanup)
    @i1.go
  end
  
  it "should create and push the new (expected) value to the right place" do
    @context.stacks[:name].push(ReferencePoint.new("foo"))
    @i1.go
    @context.stacks[:name].depth.should == 0
    @context.stacks[:code].peek.value.should == "ref foo"
  end
end