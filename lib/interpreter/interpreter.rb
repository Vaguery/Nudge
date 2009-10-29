module Nudge
  
  # The Interpreter class executes the Push3 language loop:
  # 1. Pop the top item off the <b>:exec</b> Stack
  # 2. If it is a(n)...
  #    * ... Instruction, execute its go() method;
  #    * ... Literal or Sample, push its value to the Stack it names;
  #    * ... Reference (Variable or Name), ...
  #       * ... if it's bound to a value, push the bound value onto the <b>:exec</b> Stack;
  #       * ... if it's not bound, push the name itself onto the <b>:name</b> Stack;
  #    * ... CodeBlock, push its #contents (in the same order) back onto the <b>:exec</b> Stack
  
  class Interpreter
    attr_accessor :parser, :stepLimit, :steps, :stacks
    
    # A program to be interpreted can be passed in as an optional parameter
    def initialize(initialProgram=nil)
      @parser = NudgeLanguageParser.new()
      @stacks ||=  Hash.new {|hash, key| hash[key] = Stack.new(key) }
      if initialProgram
        self.reset(initialProgram)
      end
      @stepLimit = 3000
      @steps = 0
    end
    
    # Resets the Interpreter state:
    # * clears all the Stacks (including the <b>:exec</b> Stack)
    # * loads a new program,
    #    * parses the program
    #    * if it parses, pushes it onto the <b>:exec</b> Stack
    #    * (and if it doesn't parse, leaves all stacks empty)
    # * resets the @step counter.
    def reset(program="")
      self.clear_stacks
      @steps = 0
      parsed = @parser.parse(program)
      newCode = parsed.to_points if parsed
      @stacks[:exec].push(newCode)
    end
    
    
    def clear_stacks
      @stacks = Hash.new {|hash, key| hash[key] = Stack.new(key) }
    end
    
    # Checks to see if either stopping condition applies:
    # 1. Is the <b>:exec</b> stack empty?
    # 2. Are the number of steps greater than self.stepLimit?
    def notDone?
      @stacks[:exec].depth > 0 && @steps < @stepLimit
    end
    
    # Execute one cycle of the Push3 interpreter rule:
    # 1. check termination conditions with self.notDone()?
    # 2. pop one item from <b>:exec</b>
    # 3. call its go() method
    # 4. increment the step counter self#steps
    def step
      if notDone?
        nextPoint = @stacks[:exec].pop
        nextPoint.go(self)
        @steps += 1
      end
    end
    
    # invoke self.step() until a termination condition is true
    def run
      while notDone?
        self.step
      end
    end
    
  end
end