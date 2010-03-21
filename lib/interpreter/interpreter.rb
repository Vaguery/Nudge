#encoding: utf-8
module Nudge
  
  # The Interpreter class executes the Push3 language loop:
  # 1. Pop the top item off the <b>:exec</b> Stack
  # 2. If it is a(n)...
  #    * ... InstructionPoint, execute its go() method;
  #    * ... ValuePoint, push its value to the Stack it names;
  #    * ... ReferencePoint (Variable or Name), ...
  #       * ... if it's bound to a value, push the bound value onto the <b>:exec</b> Stack;
  #       * ... if it's not bound, push the name itself onto the <b>:name</b> Stack;
  #    * ... CodeblockPoint, push its #contents (in the same order) back onto the <b>:exec</b> Stack
  
  class Interpreter
    attr_accessor :program, :stepLimit, :steps
    attr_accessor :stacks, :instructions_library, :variables, :names, :types
    attr_accessor :last_name, :evaluate_references
    
    
    # A program to be interpreted can be passed in as an optional parameter
    def initialize(params = {})
      initialProgram = params[:program] || nil
      @program = initialProgram
      @types = params[:types] || NudgeType.all_types
      @stepLimit = params[:step_limit] || 3000
      
      instructions = params[:instructions] || []
      @instructions_library = Hash.new {|hash, key| raise InstructionPoint::InstructionNotFoundError,
        "#{key} is not an active instruction in this context"}
      instructions.each {|i| self.enable(i)}
      
      # private parts
      @names = Hash.new
      @variables = Hash.new
      @steps = 0
      @last_name = "refAAAAA"
      @evaluate_references = true
      @stacks =  Hash.new {|hash, key| hash[key] = Stack.new(key) }
      
      # set it all up here
      self.reset(initialProgram)
    end
    
    
    # Resets the Interpreter state:
    # * clears all the Stacks (including the <b>:exec</b> Stack)
    # * loads a new program,
    #    * parses the program
    #    * if it parses, pushes it onto the <b>:exec</b> Stack
    #    * (and if it doesn't parse, leaves all stacks empty)
    # * resets the @step counter.
    def reset(program=nil)
      @program = program
      self.clear_stacks
      self.reset_names
      if program
        @stacks[:exec].push(NudgeProgram.new(program).linked_code)
      end
      @steps = 0
      @evaluate_references = true
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
    
    
    def instructions
      @instructions_library.keys
    end
    
    
    # invoke self.step() until a termination condition is true
    def run
      while notDone?
        self.step
      end
    end
    
    
    def lookup(name)
      @variables[name] || @names[name]
    end
    
    
    def references
      @names.merge(@variables).keys
    end
    
    
    def enable(item)
      if item.superclass == Instruction
        @instructions_library[item] = item.new(self)
      elsif item.include? NudgeType
        @types |= [item]
      end
    end
    
    
    def active?(item)
      if item.superclass == Instruction
        @instructions_library.include?(item)
      elsif item.include? NudgeType        
        @types.include?(item)
      end
    end
    
    
    def bind_variable(name, value)
      raise(ArgumentError, "Variables can only be bound to ProgramPoints") unless
        value.kind_of?(ProgramPoint)
      @variables[name] = value
    end
    
    
    def bind_name(name, value)
      raise(ArgumentError, "Names can only be bound to ProgramPoints") unless
        value.kind_of?(ProgramPoint)
      @names[name] = value
    end
    
    
    def next_name
      @last_name = @last_name.next
    end
    
    
    def unbind_variable(name)
      @variables.delete(name)
    end
    
    
    def unbind_name(name)
      @names.delete(name)
    end
    
    
    def reset_variables
      @variables = Hash.new
    end
    
    
    def reset_names
      @names = Hash.new
    end
    
    
    def enable_all_instructions
      Instruction.all_instructions.each do |i|
        @instructions_library[i] = i.new(self)
      end
    end
    
    
    def enable_all_types
      @types = NudgeType.all_types
    end
    
    
    def disable(item)
      if item.superclass == Instruction
        @instructions_library.delete(item)
      elsif item.include? NudgeType
        @types.delete(item)
      end
    end
    
    
    def disable_all_instructions
      @instructions_library = Hash.new
    end
    
    
    def disable_all_types
      @types = []
    end
  end
end