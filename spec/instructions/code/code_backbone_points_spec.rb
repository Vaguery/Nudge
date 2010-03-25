#encoding: utf-8
require File.join(File.dirname(__FILE__), "../../spec_helper")
include Nudge


describe CodeBackbonePointsInstruction do
  
  it_should_behave_like "every Nudge Instruction"
  
  before(:each) do
    @context = Interpreter.new
    @i1 = CodeBackbonePointsInstruction.new(@context)
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = CodeBackbonePointsInstruction.new(@context)
    end


    describe "\#cleanup" do
      it "should push an :int counting points in the backbone of the top :code item" do
        @context.stacks[:code].push(ValuePoint.new("code","block {ref x}"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 1
        
        @context.stacks[:code].push(ValuePoint.new("code",
          "block {ref a block {ref c ref d} block {ref ee}}"))
        @i1.go
        @context.stacks[:int].peek.value.should == 3
      end
      
      it "should push a 0 if the top :code item is not a CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code","ref x"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 0
      end
      
      it "should push a 0 if the top :code item is an empty CodeblockPoint" do
        @context.stacks[:code].push(ValuePoint.new("code","block {}"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 0
      end
      
      it "should count non-parsing programs as having 0 points" do
        @context.stacks[:code].push(ValuePoint.new("code","I have no idea whatsoever"))
        @i1.go
        @context.stacks[:int].depth.should == 1
        @context.stacks[:int].peek.value.should == 0
      end
    end
  end
end
