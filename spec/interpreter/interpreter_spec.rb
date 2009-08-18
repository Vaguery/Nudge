require File.join(File.dirname(__FILE__), "/../spec_helper")

describe "Interpreter" do
  
  describe "Channels" do
    describe "should have a variable binding hash" do
      
      it "should default to an empty hash"
    
      describe "with method #update_variable" do
        it "should take a string and a value as arguments"
          
        it "should replace the value of a pre-existing variable with the new one"
        
        it "should add the pair to the hash if it's not already there"
      end
    end
  
    describe "should have a name binding hash" do
      it "should always be initialized to an empty hash"
    
      describe "with method #update_name" do
        it "should take a string and a value as arguments"
          
        it "should replace the value of a pre-existing name with the new one"
        
        it "should add the pair to the hash if it's not already there"
      end
    end
      
  describe "active stacks" do
    it "should always include the :exec stack"
    
    it "should always include the :name stack"
    
    it "should include a stack of every type mentioned by any instruction in its library"
  end
    
    it "should include a stack of every type mentioned by a variable binding"
  end
  
  describe "instruction registry" do
    it "should use #add_instruction to add a RegistryEntry instance to #instructions"
    
    describe "all_requirements" do
      it "should return every requirement and effect of every instruction"
    end
  end
  
  it "should have an execution counter that initializes to 0"
  
  it "should have an execution limit that defaults to 3000 steps"
  
  it "should have a code_limit that defaults to 1000 points"
  
  it "should have an NOOP counter"
  
  it "should use a callback system for the NOOP counter"
  
  describe "depth" do
    it "should return the number of items on the :exec stack"
  end
  
  describe "load" do
    it "should take a Code item and push it onto the :exec stack"
  end
  
  describe "done" do
    it "should have a #done? flag that is set when a termination condition is met"
    
    it "should not do anything AT ALL when asked to #step when done? is true"
  end
  
  describe "step method" do
    it "should pop top item on :exec stack"
    
    
    describe "processing :exec item" do
      it "should unwrap Code contents and push them in order back onto :exec stack"
      
      it "should look up values of bound Channels and push them onto :exec stack"
      
      it "should preferentially choose a variable binding over a similar name if present"
      
      
      it "should push Channels that aren't defined in the source to the :name stack"
      
      it "should push Literals onto the stack of the specified type"
      
      it "should push Ercs onto the stack of the specified type"
      
      
      describe "instruction counting" do
        it "should increment the execution counter for every :exec item it pops"
      end
      
      it "should raise an exception if there is an unknown item on the stack"
      
      describe "OpCodes" do
        it "should execute the OpCode's linked Instruction"
        
        it "should fail silently without popping args and add one NOOP if there aren't enough requirements"
        it "should add a NOOP if a CODE-OVERFLOW occurs"
      end
    end
    
    describe "instruction details" do
      it "should be an empty Hash with no method names upon initialization"
      
      it "should load every instruction from the instructions library"
    end
    
  end
  
end