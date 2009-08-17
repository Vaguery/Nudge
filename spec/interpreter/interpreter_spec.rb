require File.join(File.dirname(__FILE__), "/../spec_helper")

include Nudge


describe "interpreter" do
  
  describe "should have a variable binding hash" do
    it "should default to an empty hash" do
      nudge = Interpreter.new()
      nudge.variables.should == {}
    end
    
    describe "Interpreter#update_variable" do
      it "should take a string and a value as arguments" do
        nudge = Interpreter.new()
        val = Literal.new(:int, 3)
        nudge.update_variable("x", val)
        nudge.variables.keys.should include("x")
        nudge.variables["x"].should == val
      end
          
      it "should replace the value of a pre-existing variable with the new one" do
        nudge = Interpreter.new()
        v1 = Literal.new(:bool, false)
        nudge.update_variable("y", v1)
        v2 = Literal.new(:vector, [1,2,3])
        nudge.update_variable("y", v2)
        nudge.variables["y"].should == v2
      end
    end
  end
  
  describe "should have a name binding hash" do
    it "should always be initialized to an empty hash" do
      nudge = Interpreter.new()
      nudge.names.should == {}
    end
    
    describe "Interpreter#update_name" do
      it "should take a string and a value as arguments" do
        nudge = Interpreter.new()
        val = Literal.new(:int, 0)
        nudge.update_name("x", val)
        nudge.names.keys.should include("x")
        nudge.names["x"].should == val
      end
          
      it "should replace the value of a pre-existing name with the new one" do
        nudge = Interpreter.new()
        v1 = Literal.new(:bool, false)
        nudge.update_name("b", v1)
        v2 = Literal.new(:vector, [1,2,3])
        nudge.update_name("b", v2)
        nudge.names["b"].should == v2
      end
    end
    
  end
  
  describe "active stacks" do
    it "should always include the :exec stack" do
      nudge = Interpreter.new()
      nudge.stacks.keys.should include(:exec)
    end
    
    it "should always include the :name stack" do
      nudge = Interpreter.new()
      nudge.stacks.keys.should include(:name)
    end
    
    it "should include a stack of every type mentioned by any instruction in its library" do
      nudge = Interpreter.new()
      nudge.add_instruction(:fbz, {:foo => 1, :bar => 3}, {:baz => 1})
      nudge.add_instruction(:ttt, {:stuff => 1}, {:thing => 1})
      [:foo, :bar, :baz, :stuff, :thing].each do |type| 
        nudge.stacks.should include(type)
      end
    end
    
    it "should include a stack of every type mentioned by a variable binding" do
      moneyValue = Literal.new(:dollar, 99)
      timeValue = Literal.new(:year, 0)
      nudge = Interpreter.new()
      nudge.update_variable("cost",moneyValue)
      nudge.update_variable("lead_time",timeValue)
      nudge.variables.keys.should have(2).names
      nudge.stacks.keys.should include(:dollar)
      nudge.stacks.keys.should include(:year)
    end
  end
  
  describe "instruction registry" do
    it "should use #add_instruction to add a RegistryEntry instance to #instructions" do
      nudge = Interpreter.new()
      nudge.instructions.should == {}
      nudge.add_instruction(:int_reverse, {:int => 1}, {:int => 1})
      nudge.instructions[:int_reverse].should be_a_kind_of(RegistryEntry)
      inst = nudge.instructions[:int_reverse]
      inst.requirements.should == {:int => 1}
      inst.effects.should == {:int => 1}
      inst.stacknames.should == [:int]
    end
    
    describe "all_requirements" do
      it "should return every requirement and effect of every instruction" do
        nudge = Interpreter.new()
        nudge.add_instruction(:foo_bar, {:foo => 1}, {:bar => 1})
        nudge.add_instruction(:bad_data, {:bad => 1}, {:data => 1})
        [:foo, :bar, :bad, :data].each do |type| 
          nudge.all_requirements.should include(type)
        end
      end
    end
    
  end
  
  
  it "should have an execution counter that initializes to 0" do
    nudge = Interpreter.new()
    nudge.steps.should == 0
  end
  
  it "should have an execution limit that defaults to 3000 steps" do
    nudge = Interpreter.new()
    nudge.step_limit.should == 3000
  end
  
  it "should have a code_limit that defaults to 1000 points" do
    nudge = Interpreter.new()
    nudge.code_limit.should == 1000
  end
  
  it "should have an NOOP counter" do
    nudge = Interpreter.new()
    nudge.NOOPs.should == 0
  end
  
  it "should use a callback system for the NOOP counter"
  
  
  describe "depth" do
    it "should return the number of items on the :exec stack" do
      nudge = Interpreter.new()
      nudge.depth.should == 0
      pip = Literal.new(:float,3.0)
      nudge.stacks[:exec].push pip
      nudge.depth.should == 1
    end
  end
  
  describe "load" do
    it "should take a Code or Leaf item and push it onto the :exec stack" do
      nudge = Interpreter.new()
      pip = Literal.new(:float,3.0)
      nudge.load(pip)
      nudge.depth.should == 1
      nudge.stacks[:exec].peek.should == pip
    end
  end
  
  describe "done" do
    it "should have a #done? bit that is set when a termination condition is met" do
      nudge = Interpreter.new()
      nudge.step_limit = 1
      v1 = Literal.new(:name, "bah")
      nudge.load(v1)
      nudge.done?.should_not == true
      nudge.step
      nudge.done?.should == true
      
      nudge = Interpreter.new()
      nudge.done?.should == true
    end
    
    it "should not do anything AT ALL when asked to #step when done? is true" do
      nudge = Interpreter.new()
      nudge.step_limit = 1
      nudge.load Literal.new(:name, "piffle")
      nudge.step
      nudge.done?.should == true
      nudge.steps.should == 1
      nudge.step
      nudge.steps.should == 1
      nudge.step
      nudge.steps.should == 1
      nudge.stacks[:name].peek.value.should == "piffle"
      
    end
  end
  
  
  describe "step method" do
    it "should pop top item on :exec stack" do
      nudge = Interpreter.new()
      pip = Literal.new(:name, "blah") #this is a cheat; literals don't have this type
      pap = Literal.new(:name, "bah")
      nudge.stacks[:exec].push pip
      nudge.stacks[:exec].push pap
      nudge.step
      nudge.depth.should == 1
      nudge.step
      nudge.depth.should == 0
    end
    
    
    describe "processing :exec item" do
      it "should unwrap Code contents and push them in order back onto :exec stack"
      
      it "should look up values of bound Channels and push them onto :exec stack" do
        xvalue = Literal.new(:int, 99)
        nudge = Interpreter.new({"x"=>xvalue})
        ch23 = Channel.new("x")
        nudge.load(ch23)
        nudge.stacks[:exec].peek.should == ch23
        nudge.step
        nudge.stacks[:exec].peek.should == xvalue
        
        yvalue = Literal.new(:bool, false)
        nudge = Interpreter.new()
        nudge.names = {"y" => yvalue}
        ch99 = Channel.new("y")
        nudge.load(ch99)
        nudge.stacks[:exec].peek.should == ch99
        nudge.step
        nudge.stacks[:exec].peek.should == yvalue
      end
      
      
      it "should preferentially choose a variable binding over a similar name if present" do
        x1value = Literal.new(:int,99)
        x2value = Literal.new(:int, 0)
        nudge = Interpreter.new()
        chx = Channel.new("x")
        nudge.variables = {"x" => x1value}
        nudge.names = {"x" => x2value}
        nudge.load(chx)
        nudge.step
        nudge.stacks[:exec].peek.should == x1value
        
        nudge.variables = {}
        nudge.names = {"x" => x2value}
        nudge.load(chx)
        nudge.step
        nudge.stacks[:exec].peek.should == x2value
        
        nudge.variables = {}
        nudge.names = {}
        nudge.load(chx)
        nudge.step
        nudge.stacks[:name].peek.should == chx
      end
      
      
      it "should push Channels that aren't defined in the source to the :name stack" do
        nudge = Interpreter.new()
        ch33 = Channel.new("x")
        nudge.load(ch33)
        nudge.stacks[:exec].peek.should == ch33
        nudge.step
        nudge.stacks[:name].peek.should == ch33
        nudge.depth.should == 0
      end
      
      
      it "should push Literals onto the stack of the specified type"
      
      it "should push Ercs onto the stack of the specified type"
      
      
      describe "instruction counting" do
        it "should increment the execution counter for every :exec item it pops"
      end
      
      it "should raise an exception if there is an unknown item on the stack" do
        nudge = Interpreter.new()
        nudge.load( "badString" )
        lambda {nudge.step}.should raise_error(RuntimeError, ":exec stack contains an unknown class")
      end
      
      describe "OpCodes" do
        it "should execute the OpCode's linked Instruction"
        
        it "should fail silently without popping args and add one NOOP if there aren't enough requirements"
        it "should add a NOOP if a CODE-OVERFLOW occurs"
      end
    end
    
    describe "instruction details" do
      it "should be an empty Hash with no method names upon initialization" do
        nudge = Interpreter.new()
        nudge.instructions.should == {}
      end
      
      it "should load every instruction from the instructions library"
    end
    
  end
  
end