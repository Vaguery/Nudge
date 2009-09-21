require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "Literal" do
  
    it "should be a kind of program point" do
      myL = Literal.new("int", 4)
      myL.should be_a_kind_of(ProgramPoint)
    end
    
    it "should be initialized with a type and a value, with no defaults" do
      myL = Literal.new("int", 4)
      myL.should be_a_kind_of(Literal)
      myL.type.should == "int"
      myL.value.should == 4
      lambda{Literal.new()}.should raise_error(ArgumentError)
      lambda{Literal.new("bool")}.should raise_error(ArgumentError)
    end
    
    it "should move to the appropriate stack when removed from the exec stack" do
      ii = Interpreter.new("literal bool, true")
      ii.step
      Stack.stacks[:bool].peek.value.should == true
    end
    
    describe "#go" do
      before(:each) do
        @ii = Interpreter.new()
        Stack.cleanup
        Stack.stacks[:int] = Stack.new(:int)
        @ii.load("literal int,999")
      end
      
      it "should pop the exec stack when a Literal is interpreted" do
        oldExec = Stack.stacks[:exec].depth
        @ii.step
        Stack.stacks[:exec].depth.should == (oldExec-1)
      end
      
      it "should initialize the right stack for the type of the Literal if it doesn't exist" do
        Stack.stacks.delete(:int)
        @ii.step
        Stack.stacks.should include(:int)
      end
      
      it "should use the existing stack if it does exist" do
        oldInt = Stack.stacks[:int].depth
        @ii.step
        Stack.stacks[:int].depth.should == (oldInt + 1)
      end

      it "should push the value onto the right stack"
      it "should check for CODE size limits"
    end
end