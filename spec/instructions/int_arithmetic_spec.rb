require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge

describe "IntAddInstruction" do
  it "should be a singleton" do
    IntAddInstruction.instance.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
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
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        Stack.cleanup
        1.times {Stack.stacks[:int].push(@int1)}
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end

      it "should successfully run #go only if all preconditions are met" do
        Stack.stacks[:int].push(@int1)
        Stack.stacks[:int].push(@int1)
        @i1.should_receive(:cleanup)
        @i1.go
      end
    end

    describe "#derive" do
      it "should pop the arguments" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        Stack.stacks[:int].depth.should == 0
      end
      
      it "determine the result value before it gets consumed!" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.should_receive(:cleanup).and_return(@i1.instance_eval("@result.value"))
        @i1.go.should == 12
      end
    end

    describe "#cleanup" do
      it "should push! the result" do
        2.times {Stack.stacks[:int].push(@int1)}
        @i1.go
        Stack.stacks[:int].peek.value.should == 12
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

  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
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
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @im.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        Stack.cleanup
        1.times {Stack.stacks[:int].push(@int1)}
        lambda{@im.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end

      it "should successfully run #go only if all preconditions are met" do
        Stack.stacks[:int].push(@int1)
        Stack.stacks[:int].push(@int1)
        @im.should_receive(:cleanup)
        @im.go
      end
    end

    describe "#derive" do
      it "should pop the arguments" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @im.stub!(:cleanup) # and do nothing
        @im.go
        Stack.stacks[:int].depth.should == 0
      end

      it "determine the result value before it gets consumed!" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @im.should_receive(:cleanup).and_return(@im.instance_eval("@result.value"))
        @im.go.should == 36
      end
    end

    describe "#cleanup" do
      it "should push! the result" do
        2.times {Stack.stacks[:int].push(@int1)}
        @im.go
        Stack.stacks[:int].peek.value.should == 36
      end
    end
  end
end


describe "IntDivideInstruction" do
  it "should be a singleton" do
    i1 = IntDivideInstruction.instance
    i2 = IntDivideInstruction.instance
    i1.should === i2
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    before(:each) do
      @i1 = IntDivideInstruction.instance
    end
    it "should respond to #{methodName}" do
      @i1.should respond_to(methodName)
    end 
  end
  
  describe "four phases of #going" do
    before(:each) do
      @i1 = IntDivideInstruction.instance
      Stack.cleanup
      @int1 = LiteralPoint.new("int", 6)
    end
    
    describe "#preconditions?" do
      it "should check that there are at least 2 ints" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        Stack.cleanup
        1.times {Stack.stacks[:int].push(@int1)}
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end

      it "should successfully run #go only if all preconditions are met" do
        Stack.stacks[:int].push(@int1)
        Stack.stacks[:int].push(@int1)
        @i1.should_receive(:cleanup)
        @i1.go
      end
    end

    describe "#derive" do
      it "should pop the arguments" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        Stack.stacks[:int].depth.should == 0
      end
      
      it "determine the result value before it gets consumed!" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.should_receive(:cleanup).and_return(@i1.instance_eval("@result.value"))
        @i1.go.should == 1
      end
      
      it "should raise the right exceptions if a bad thing happens" do
        Stack.cleanup
        @i1 = IntDivideInstruction.instance
        Stack.stacks[:int].push(LiteralPoint.new("int",99))
        Stack.stacks[:int].push(LiteralPoint.new("int",0))
        @i1.setup
        lambda{@i1.derive}.should raise_error(Instruction::InstructionMethodError)
      end
    end

    describe "#cleanup" do
      it "should push! the result" do
        2.times {Stack.stacks[:int].push(@int1)}
        @i1.go
        Stack.stacks[:int].peek.value.should == 1
      end
    end
  end
end


describe "IntSubtractInstruction" do
  it "should be a singleton" do
    IntSubtractInstruction.instance.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    before(:each) do
      @i1 = IntSubtractInstruction.instance
    end
    it "should respond to #{methodName}" do
      @i1.should respond_to(methodName)
    end 
  end
  
  describe "four phases of #going" do
    before(:each) do
      @i1 = IntSubtractInstruction.instance
      Stack.cleanup
      @int1 = LiteralPoint.new("int", 2)
      @int2 = LiteralPoint.new("int", 4)
    end
    
    describe "#preconditions?" do
      it "should check that there are at least 2 ints" do
        2.times {Stack.stacks[:int].push(@int1)}
        @i1.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        Stack.cleanup
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
    end

    describe "#derive" do
      it "should pop the arguments" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        Stack.stacks[:int].depth.should == 0
      end
    end

    describe "#cleanup" do
      it "should push the correct result" do
        Stack.cleanup
        Stack.stacks[:int].push(@int1)
        Stack.stacks[:int].push(@int2)
        @i1.go
        Stack.stacks[:int].peek.value.should == -2
      end
    end
  end
end


describe "IntModuloInstruction" do
  it "should be a singleton" do
    IntModuloInstruction.instance.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    before(:each) do
      @i1 = IntModuloInstruction.instance
    end
    it "should respond to #{methodName}" do
      @i1.should respond_to(methodName)
    end 
  end
  
  describe "four phases of #going" do
    before(:each) do
      @i1 = IntModuloInstruction.instance
      Stack.cleanup
      @int1 = LiteralPoint.new("int", 3)
      @int2 = LiteralPoint.new("int", -4)
    end
    
    describe "#preconditions?" do
      it "should check that there are at least 2 ints" do
        2.times {Stack.stacks[:int].push(@int1)}
        @i1.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        Stack.cleanup
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
    end

    describe "#derive" do
      it "should pop the arguments" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        Stack.stacks[:int].depth.should == 0
      end
      
      it "should raise the right exceptions if a bad thing happens" do
        Stack.cleanup
        @i1 = IntModuloInstruction.instance
        Stack.stacks[:int].push(LiteralPoint.new("int",-100))
        Stack.stacks[:int].push(LiteralPoint.new("int",0))
        @i1.setup
        lambda{@i1.derive}.should raise_error(Instruction::InstructionMethodError)
      end
      
    end

    describe "#cleanup" do
      it "should push the correct result" do
        Stack.cleanup
        Stack.stacks[:int].push(LiteralPoint.new("int", 3))
        Stack.stacks[:int].push(LiteralPoint.new("int", -4))
        @i1.go
        Stack.stacks[:int].peek.value.should == -1 # -4 % 3 = -1 (not #remainder!)
      end
    end
  end
end


describe "IntMaxInstruction" do
  it "should be a singleton" do
    IntMaxInstruction.instance.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    before(:each) do
      @i1 = IntMaxInstruction.instance
    end
    it "should respond to #{methodName}" do
      @i1.should respond_to(methodName)
    end 
  end
  
  describe "four phases of #going" do
    before(:each) do
      @i1 = IntMaxInstruction.instance
      Stack.cleanup
      @int1 = LiteralPoint.new("int", 3)
      @int2 = LiteralPoint.new("int", -4)
    end
    
    describe "#preconditions?" do
      it "should check that there are at least 2 ints" do
        2.times {Stack.stacks[:int].push(@int1)}
        @i1.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        Stack.cleanup
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
    end

    describe "#derive" do
      it "should pop the arguments" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        Stack.stacks[:int].depth.should == 0
      end
    end

    describe "#cleanup" do
      it "should push the correct result" do
        Stack.cleanup
        Stack.stacks[:int].push(LiteralPoint.new("int", 10))
        Stack.stacks[:int].push(LiteralPoint.new("int", 3))
        Stack.stacks[:int].push(LiteralPoint.new("int", -4))
        @i1.go
        Stack.stacks[:int].peek.value.should == 3
        @i1.go
        Stack.stacks[:int].peek.value.should == 10
      end
    end
  end
end


describe "IntMinInstruction" do
  it "should be a singleton" do
    IntMinInstruction.instance.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    before(:each) do
      @i1 = IntMinInstruction.instance
    end
    it "should respond to #{methodName}" do
      @i1.should respond_to(methodName)
    end 
  end
  
  describe "four phases of #going" do
    before(:each) do
      @i1 = IntMinInstruction.instance
      Stack.cleanup
      @int1 = LiteralPoint.new("int", 3)
      @int2 = LiteralPoint.new("int", -4)
    end
    
    describe "#preconditions?" do
      it "should check that there are at least 2 ints" do
        2.times {Stack.stacks[:int].push(@int1)}
        @i1.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        Stack.cleanup
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
    end

    describe "#derive" do
      it "should pop the arguments" do
        2.times {Stack.stacks[:int].push(@int1)}
        Stack.stacks[:int].depth.should == 2
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        Stack.stacks[:int].depth.should == 0
      end
    end

    describe "#cleanup" do
      it "should push the correct result" do
        Stack.cleanup
        Stack.stacks[:int].push(LiteralPoint.new("int", -10))
        Stack.stacks[:int].push(LiteralPoint.new("int", 3))
        Stack.stacks[:int].push(LiteralPoint.new("int", -4))
        @i1.go
        Stack.stacks[:int].peek.value.should == -4
        @i1.go
        Stack.stacks[:int].peek.value.should == -10
      end
    end
  end
end


describe "IntAbsInstruction" do
  it "should be a singleton" do
    IntAbsInstruction.instance.should be_a_kind_of(Singleton)
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    before(:each) do
      @i1 = IntAbsInstruction.instance
    end
    it "should respond to #{methodName}" do
      @i1.should respond_to(methodName)
    end 
  end
  
  describe "four phases of #going" do
    before(:each) do
      @i1 = IntAbsInstruction.instance
      Stack.cleanup
      @int1 = LiteralPoint.new("int", 0)
      @int2 = LiteralPoint.new("int", -400)
    end
    
    describe "#preconditions?" do
      it "should check that there are at least 1 ints" do
        Stack.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end

      it "should raise an error if the preconditions aren't met" do
        Stack.cleanup
        lambda{@i1.preconditions?}.should raise_error(Instruction::NotEnoughStackItems)
      end
    end

    describe "#derive" do
      it "should pop the arguments" do
        Stack.stacks[:int].push(@int1)
        Stack.stacks[:int].depth.should == 1
        @i1.stub!(:cleanup) # and do nothing
        @i1.go
        Stack.stacks[:int].depth.should == 0
      end
    end

    describe "#cleanup" do
      it "should push the correct result" do
        Stack.cleanup
        Stack.stacks[:int].push(LiteralPoint.new("int", -10))
        Stack.stacks[:int].push(LiteralPoint.new("int", 0))
        Stack.stacks[:int].push(LiteralPoint.new("int", 11))
        @i1.go
        Stack.stacks[:int].peek.value.should == 11
        Stack.stacks[:int].pop
        @i1.go
        Stack.stacks[:int].peek.value.should == 0
        Stack.stacks[:int].pop
        @i1.go
        Stack.stacks[:int].peek.value.should == 10
        
      end
    end
  end
end