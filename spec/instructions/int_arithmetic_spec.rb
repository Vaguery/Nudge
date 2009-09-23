require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "IntAddInstruction" do
  it "should be a singleton" do
    i1 = IntAddInstruction.instance
    i2 = IntAddInstruction.instance
    i1.should === i2
  end
  
  [:setup, :derive, :cleanup].each do |methodName|
    before(:each) do
      @i1 = IntAddInstruction.instance
    end
    it "should respond to #{methodName}" do
      @i1.should respond_to(methodName)
    end 
  end
  
  describe "three phases of #going" do
    before(:each) do
      @i1 = IntAddInstruction.instance
      Stack.cleanup
      @int1 = LiteralPoint.new("int", 6)
    end
    
    describe "#preconditions?" do
      it "should check that there are at least 2 ints" do
        2.times {Stack.push!(:int,@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        1.times {Stack.push!(:int,@int1)}
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end

      it "should successfully run #go only if all preconditions are met" do
        Stack.push!(:int,@int1)
        Stack.push!(:int,@int1)
        @i1.should_receive(:cleanup)
        @i1.go
      end
    end

    describe "#go" do
      it "should pop the arguments" do
        2.times {Stack.push!(:int,@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        Stack.stacks[:int].depth.should == 0
      end
      
      it "determine the result value" do
        2.times {Stack.push!(:int,@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.should_receive(:cleanup).and_return(@i1.instance_eval("@result.value"))
        @i1.go.should == 12
      end
      
      it "should raise the right exceptions if a bad thing happens" do
        pending
      end
      
    end

    describe "#outcomes" do
      it "should push! the result" do
        2.times {Stack.push!(:int,@int1)}
        @i1.go
        Stack.stacks[:int].peek.value.should == 12
      end
      
      it "should raise the right exception if something bad happens" do
        pending
      end
    end
  end
end

describe "IntMultiplyInstruction" do
  it "should be a singleton" do
    i1 = IntMultiplyInstruction.instance
    i2 = IntMultiplyInstruction.instance
    i1.should === i2
  end

  [:setup, :derive, :cleanup].each do |methodName|
    before(:each) do
      @im = IntMultiplyInstruction.instance
    end
    it "should respond to #{methodName}" do
      @im.should respond_to(methodName)
    end 
  end

  describe "three phases of #going" do
    before(:each) do
      @im = IntMultiplyInstruction.instance
      Stack.cleanup
      @int1 = LiteralPoint.new("int", 6)
    end

    describe "#preconditions?" do
      it "should check that there are at least 2 ints" do
        2.times {Stack.push!(:int,@int1)}
        Stack.stacks[:int].depth.should == 2
        @im.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        1.times {Stack.push!(:int,@int1)}
        lambda{@im.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end

      it "should successfully run #go only if all preconditions are met" do
        Stack.push!(:int,@int1)
        Stack.push!(:int,@int1)
        @im.should_receive(:cleanup)
        @im.go
      end
    end

    describe "#go" do
      it "should pop the arguments" do
        2.times {Stack.push!(:int,@int1)}
        Stack.stacks[:int].depth.should == 2
        @im.stub!(:cleanup) # and do nothing
        @im.go
        Stack.stacks[:int].depth.should == 0
      end

      it "determine the result value" do
        2.times {Stack.push!(:int,@int1)}
        Stack.stacks[:int].depth.should == 2
        @im.should_receive(:cleanup).and_return(@im.instance_eval("@result.value"))
        @im.go.should == 36
      end

      it "should raise the right exceptions if a bad thing happens" do
        pending
      end

    end

    describe "#outcomes" do
      it "should push! the result" do
        2.times {Stack.push!(:int,@int1)}
        @im.go
        Stack.stacks[:int].peek.value.should == 36
      end

      it "should raise the right exception if something bad happens" do
        pending
      end
    end
  end
end