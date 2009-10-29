require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge


theseInstructions = [
  IntRandomInstruction,
  BoolRandomInstruction,
  FloatRandomInstruction
  ]
  
whatItMakes = {
  IntRandomInstruction => {:where => :int, :what => IntType},
  BoolRandomInstruction => {:where => :bool, :what => BoolType},
  FloatRandomInstruction => {:where => :float, :what => FloatType}
}


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
        @stackName = whatItMakes[instName][:where]
      end
      
      describe "\#preconditions?" do
        it "should check that there are enough parameters" do
          # there are none, for these instructions
          @i1.preconditions?.should == true
        end
      end
        
      describe "\#cleanup" do
        it "should invoke Type#any_value" do
          @context.clear_stacks
          whatItMakes[instName][:what].should_receive(:any_value)
          @i1.go
        end
        
        it "should have a created a new instance of the right type and pushed it" do
          @context.clear_stacks
          @i1.go
          @context.stacks[@stackName].depth.should == 1
          result = @context.stacks[@stackName].peek
          result.value.should_not == nil
          result.type.should == @stackName
        end
      end
    end
  end
end
