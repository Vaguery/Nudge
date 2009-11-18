require File.join(File.dirname(__FILE__), "/../spec_helper")
include Nudge


describe ExecYInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecYInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = ExecYInstruction.new(@context)
      @context.reset("do int_add")
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should end up with a block {do exec_y [something]} in the second position on the :exec stack" do
        @context.stacks[:exec].depth.should == 1
        @i1.go
        @context.stacks[:exec].depth.should == 2
        @context.stacks[:exec].peek.listing.should == "do int_add"
        @context.stacks[:exec].entries[0].points.should == 3
        @context.stacks[:exec].entries[0].listing.should include("do exec_y")
        @context.stacks[:exec].entries[0].listing.should include(@context.stacks[:exec].peek.listing)
      end
    end
  end
end


describe ExecKInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecKInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = ExecKInstruction.new(@context)
      @context.reset("block { do int_add do int_subtract }")
      @context.step # unwrapping the two instructions
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least two items" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should delete the item from the second position on the :exec stack" do
        @context.stacks[:exec].depth.should == 2
        @i1.go
        @context.stacks[:exec].depth.should == 1
        @context.stacks[:exec].peek.listing.should == "do int_add"
      end
    end
  end
end


describe ExecSInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecSInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = ExecSInstruction.new(@context)
      @context.reset("block { do int_add do int_subtract do int_multiply}")
      @context.step # unwrapping the three instructions
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least three items" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should result in the top one [replaced], the old 3rd one, then a block with the 2nd and 3rd" do
        @context.stacks[:exec].depth.should == 3
        @i1.go
        @context.stacks[:exec].depth.should == 3
        @context.stacks[:exec].entries[2].listing.should == "do int_add" # old top one
        @context.stacks[:exec].entries[1].listing.should == "do int_multiply" # old 3rd one
        @context.stacks[:exec].entries[0].listing.should == "block {do int_subtract do int_multiply}"
      end
    end
  end
end



describe ExecPopInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecPopInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = ExecPopInstruction.new(@context)
      @context.reset("block {literal float(-2.1)\nliteral float(-2.1)}")
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should remove one item from the stack" do
        @context.step
        @context.stacks[:exec].depth.should == 2
        @i1.go
        @context.stacks[:exec].depth.should == 1
      end
    end
  end
end


describe ExecDuplicateInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecDuplicateInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @myInterpreter = Interpreter.new
      @i1 = ExecDuplicateInstruction.new(@myInterpreter)
      @myInterpreter.reset("literal bool(false)")
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should push a copy of the top item onto the :exec stack" do
        @i1.go
        @myInterpreter.stacks[:exec].depth.should == 2
        @myInterpreter.stacks[:exec].entries[0].value.should == @myInterpreter.stacks[:exec].entries[1].value
      end
      
      it "should not be the same objectID, just in case" do
        @i1.go
        id1 = @myInterpreter.stacks[:exec].entries[0].object_id
        id2 = @myInterpreter.stacks[:exec].entries[1].object_id
        id1.should_not == id2
      end
    end
  end
end


describe ExecSwapInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecSwapInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @myInterpreter = Interpreter.new
      @i1 = ExecSwapInstruction.new(@myInterpreter)
      @myInterpreter.reset("block{literal bool(false) literal int(88)}")
      @myInterpreter.step # [pushing the two points]
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should push a copy of the top item onto the :exec stack" do
        @myInterpreter.stacks[:exec].entries[0].value.should == 88
        @myInterpreter.stacks[:exec].entries[1].value.should == false
        @i1.go
        @myInterpreter.stacks[:exec].depth.should == 2
        @myInterpreter.stacks[:exec].entries[0].value.should == false
        @myInterpreter.stacks[:exec].entries[1].value.should == 88
      end
    end
  end
end


describe ExecDepthInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecDepthInstruction.new(@context)
  end
  
  it "should have its context set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = ExecDepthInstruction.new(@context)
      @context.reset("block{literal bool(false) literal int(88) block {}}")
    end
    
    describe "\#preconditions?" do
      it "should check that the :bool stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should count the items on the stack and push it onto the :int stack" do
        @context.stacks[:int].depth.should == 0
        @i1.go
        @context.stacks[:int].peek.value.should == 1
        @context.step # unpacking the three points onto :exec
        @i1.go
        @context.stacks[:int].peek.value.should == 3
      end
    end
  end
end



describe ExecFlushInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecFlushInstruction.new(@context)
  end
  
  it "should have a context upon creation" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = ExecFlushInstruction.new(@context)
      @context.reset("block{literal bool(false) literal int(88) block {}}")
    end
    
    describe "\#preconditions?" do
      it "should check that the :exec stack responds to #depth" do
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      it "should remove all items on the :exec stack" do
        @context.step
        @context.stacks[:exec].depth.should == 3
        @i1.go
        @context.stacks[:exec].depth.should == 0
      end
    end
  end
end


describe ExecRotateInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecRotateInstruction.new(@context)
  end
  
  it "should have the right context" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context = Interpreter.new
      @i1 = ExecRotateInstruction.new(@context)
      @context.reset("block{literal bool(false) literal int(88) literal float(0.5)}")
      @context.step # [pushing the 3 points]
    end

    describe "\#preconditions?" do
      it "should check that the :exec stack has at least one item" do
        @i1.preconditions?.should == true
      end
    end

    describe "\#cleanup" do
      it "should rearrange the three items on the :exec stack" do
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [0.5, 88, false] # because the stacks are "backwards" in array form
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [88, false, 0.5] # bottom one comes to top
      end
    end
  end
end


describe ExecYankdupInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecYankdupInstruction.new(@context)
  end
  
  it "should check its context is set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @context.clear_stacks
      @i1 = ExecYankdupInstruction.new(@context)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :exec item" do
        @context.reset("block {}")
        @context.stacks[:int].push(LiteralPoint.new("int",2))
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (1..3).each {|i| @context.stacks[:exec].push(LiteralPoint.new("float",i*1.0))}
      end
      
      it "should duplicate the top item if the position integer is negative" do
        @context.stacks[:int].push(LiteralPoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0,3.0]
      end
      
      it "should duplicate the top item if the position integer is zero" do
        @context.stacks[:int].push(LiteralPoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0, 3.0]
      end
      
      it "should clone the bottom item and push it if the position is more than the stackdepth" do
        @context.stacks[:int].push(LiteralPoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0, 1.0]
      end
      
      it "should push a copy of the indicated item to the top of the stack, counting from the 'top down'" do
        @context.stacks[:int].push(LiteralPoint.new("int", 2))
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0, 1.0]
        
        @context.stacks[:int].push(LiteralPoint.new("int", 2))
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [1.0,2.0,3.0, 1.0, 2.0]
      end
    end
  end
end


describe ExecYankInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecYankInstruction.new(@context)
  end
  
  it "should check its context is set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = ExecYankInstruction.new(@context)
      @context.clear_stacks
      @int1 = LiteralPoint.new("int", 3)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one more :int" do
        @context.stacks[:exec].push(LiteralPoint.new("float", -99.99))
        @context.stacks[:int].push(@int1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        (1..3).each {|i| @context.stacks[:exec].push(LiteralPoint.new("float",i*0.5))}
      end
      
      it "should not change anything if the position integer is negative" do
        @context.stacks[:int].push(LiteralPoint.new("int", -99))
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [0.5,1.0,1.5]
      end
      
      it "should not change anything if the position integer is zero" do
        @context.stacks[:int].push(LiteralPoint.new("int", 0))
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [0.5,1.0,1.5]
      end
      
      it "should pull the last item on the stack to the top if the position is more than the stackdepth" do
        @context.stacks[:int].push(LiteralPoint.new("int", 1000))
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [1.0,1.5, 0.5]
      end
      
      it "should yank the indicated item to the top of the stack, counting from the 'top' 'down'" do
        @context.stacks[:int].push(LiteralPoint.new("int", 1))
        @i1.go
        and_now = @context.stacks[:exec].entries.collect {|i| i.value}
        and_now.should == [0.5,1.5, 1.0]
      end
    end
  end
end


describe ExecShoveInstruction do
  before(:each) do
    @context = Interpreter.new
    @i1 = ExecShoveInstruction.new(@context)
  end
  
  it "should check its context is set" do
    @i1.context.should == @context
  end
  
  [:preconditions?, :setup, :derive, :cleanup].each do |methodName|
    it "should respond to \##{methodName}" do
      @i1.should respond_to(methodName)
    end   
  end
  
  describe "\#go" do
    before(:each) do
      @i1 = ExecShoveInstruction.new(@context)
      @context.clear_stacks
      @float1 = LiteralPoint.new("float", 9.9)
    end
    
    describe "\#preconditions?" do
      it "should check that there is one :int and at least one :float" do
        @context.stacks[:int].push(LiteralPoint.new("int", 4))
        @context.stacks[:exec].push(@float1)
        @i1.preconditions?.should == true
      end
    end
    
    describe "\#cleanup" do
      before(:each) do
        @context.clear_stacks
        11.times {@context.stacks[:exec].push(@float1)}
        @context.stacks[:exec].push(LiteralPoint.new("float", 1.1)) # making it 12 deep
      end
      
      it "should not move the top item if the integer is negative" do
        @context.stacks[:int].push(LiteralPoint.new("int", -99))
        @i1.go
        @context.stacks[:exec].depth.should == 12
        @context.stacks[:exec].peek.value.should == 1.1
      end
      
      it "should not move the top item if the integer is zero" do
        @context.stacks[:int].push(LiteralPoint.new("int", 0))
        @i1.go
        @context.stacks[:exec].depth.should == 12
        @context.stacks[:exec].peek.value.should == 1.1
      end
      
      it "should move the top item farther down if the value is less than the depth" do
        @context.stacks[:int].push(LiteralPoint.new("int", 1000))
        @i1.go
        @context.stacks[:exec].depth.should == 12
        @context.stacks[:exec].entries[0].value.should == 1.1
      end
      
      it "should move the top item to the bottom if the value is more than the depth" do
        @context.stacks[:int].push(LiteralPoint.new("int", 4))
        @i1.go
        @context.stacks[:exec].depth.should == 12
        @context.stacks[:exec].entries[11].value.should == 9.9
        @context.stacks[:exec].entries[7].value.should == 1.1
      end
    end
  end
end