#encoding: utf-8
module Nudge
  
  # The Interpreter class executes the Push3-like language loop:
  # 1. Pop the top item off the <tt>:exec</tt> Stack
  # 2. If it is a(n)...
  #    * ... InstructionPoint, execute that instruction's go() method;
  #    * ... ValuePoint, push its value to the Stack it names;
  #    * ... ReferencePoint (a reference to a Variable or Name), ...
  #       * ... if it's bound to a value, push the bound value onto the <b>:exec</b> Stack;
  #       * ... if it's not bound, push the name itself onto the <b>:name</b> Stack;
  #    * ... CodeblockPoint, push its #contents (in the same order) back onto the <b>:exec</b> Stack
  #    * ... NilPoint, do nothing
  #
  # This cycle repeats until one of the termination conditions is met:
  #    * nothing more remains on the <tt>:exec/tt> stack
  #    * the number of cycles meets or exceeds the <tt>step_limit</tt>
  #    * the wall-clock time meets or exceeds the <tt>time_limit</tt>  
  class Interpreter
    attr_accessor :program, :step_limit, :steps
    attr_accessor :stacks, :instructions_library, :variables, :names, :types
    attr_accessor :last_name, :evaluate_references
    attr_accessor :sensors
    attr_accessor :code_char_limit
    attr_accessor :start_time, :time_limit
    
    
    def initialize(program = nil, params = {})
      initialProgram = program
      @program = initialProgram
      @types = params[:types] || NudgeType.all_types
      @step_limit = params[:step_limit] || 3000
      @time_limit = params[:time_limit] || 60.0 # seconds
      @code_char_limit = params[:code_char_limit] || 2000
      @sensors = Hash.new
      
      instructions = params[:instructions] || Instruction.all_instructions
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
    # * resets the @step counter
    # * resets the name assignments
    # * resets the start_time (intentional redundancy)
    # * resets a number of state variables
    def reset(program=nil)
      @program = program
      self.clear_stacks
      self.reset_names
      self.reset_sensors
      if !program.nil?
        @stacks[:exec].push(NudgeProgram.new(program).linked_code)
      end
      @steps = 0
      @start_time = Time.now
      @evaluate_references = true
    end
    
    
    
    # Deletes all items from all stacks
    def clear_stacks
      @stacks = Hash.new {|hash, key| hash[key] = Stack.new(key) }
    end
    
    
    # Returns the count of items in a given stack
    def depth(stackname)
      @stacks[stackname].depth
    end
    
    
    # Returns a link to the top item in a given stack (not its value)
    def peek(stackname)
      @stacks[stackname].peek
    end
    
    
    # Returns a link to the value of the top item in a given stack
    def peek_value(stackname)
      item = @stacks[stackname].peek
      item.nil? ? nil : item.value
    end
    
    
    # Removes the top item from a given stack and returns it
    def pop(stackname)
      @stacks[stackname].pop
    end
    
    
    # Removes the top item from a given stack and returns its value
    def pop_value(stackname)
      item = @stacks[stackname].pop
      item.nil? ? nil : item.value
    end
    
    
    # Adds a new ValuePoint item, with the given value, to the named stack
    def push(stackname, value="")
      @stacks[stackname].push(ValuePoint.new(stackname, value))
    end
    
    
    
    # Checks to see if either stopping condition applies:
    # 1. Is the <b>:exec</b> stack empty?
    # 2. Are the number of steps greater than self.step_limit?
    # 3. Has the total time since recorded self.start_time exceeded self.time_limit?
    def notDone?
      @stacks[:exec].depth > 0 &&
      @steps < @step_limit && 
      (Time.now-@start_time)<@time_limit
    end
    
    
    # Execute one cycle of the Push3 interpreter rule:
    # 1. check termination conditions with self.notDone()?
    # 2. pop one item from <tt>:exec</tt>
    # 3. call that item's #go method
    # 4. increment the step counter self#steps
    #
    # Note that the start_time attribute is not adjusted; if called a long time after resetting, 
    # it may time out unexpectedly.
    def step
      if notDone?
        nextPoint = @stacks[:exec].pop
        nextPoint.go(self)
        @steps += 1
      end
    end
    
    
    # Returns an Array containing the class names of all <i>active</i> instructions
    def instructions
      @instructions_library.keys
    end
    
    
    # invoke self.step() until a termination condition is true
    def run
      @start_time = Time.now
      while notDone?
        self.step
      end
      fire_all_sensors
    end
    
    
    # given a string, checks the hash of defined variables, then the names (local variables),
    # returning the bound value, or nil if it is not found
    def lookup(name)
      @variables[name] || @names[name]
    end
    
    
    # returns an Array of all strings defined as variables or names
    def references
      @names.merge(@variables).keys
    end
    
    
    # Convenience method that can be called with either an Instruction or NudgeType class as an
    # argument. If an Instruction, that class is added to the Interpreter's #instruction_library.
    # If a NudgeType, that class is added to the list of types that can be used to generate
    # random code.
    def enable(item)
      if item.superclass == Instruction
        @instructions_library[item] = item.new(self)
      elsif item.include? NudgeType
        @types |= [item]
      end
    end
    
    
    # Convenience method that checks to see whether an Instruction or NudgeType class is currently
    # in the active state. Returns a boolean.
    def active?(item)
      if item.superclass == Instruction
        @instructions_library.include?(item)
      elsif item.include? NudgeType        
        @types.include?(item)
      end
    end
    
    
    # Given a string and a ProgramPoint, binds a variable with that name to that ProgramPoint
    def bind_variable(name, value)
      raise(ArgumentError, "Variables can only be bound to ProgramPoints") unless
        value.kind_of?(ProgramPoint)
      @variables[name] = value
    end
    
    
    # Given a string and a ProgramPoint, binds a name with that name to that ProgramPoint
    def bind_name(name, value)
      raise(ArgumentError, "Names can only be bound to ProgramPoints") unless
        value.kind_of?(ProgramPoint)
      @names[name] = value
    end
    
    
    # generates an arbitrary string for naming new local variables, by incrememnting 
    # from the starting point "aaa001"
    def next_name
      @last_name = @last_name.next
    end
    
    
    # removes the named global variable from the Hash that defines them
    def unbind_variable(name)
      @variables.delete(name)
    end
    
    
    # removes the named local variable from the Hash that defines them
    def unbind_name(name)
      @names.delete(name)
    end
    
    
    # removes all global variable definitions
    def reset_variables
      @variables = Hash.new
    end
    
    
    # removes all local variable definitions
    def reset_names
      @names = Hash.new
    end
    
    
    # activates every Instruction subclass defined in any library
    def enable_all_instructions
      Instruction.all_instructions.each do |i|
        @instructions_library[i] = i.new(self)
      end
    end
    
    
    # activates every NudgeType subclass defined in any library
    def enable_all_types
      @types = NudgeType.all_types
    end
    
    
    # Convenience method that can be called with either an Instruction or NudgeType class as an
    # argument. If an Instruction, that class is removed from the Interpreter's #instruction_library.
    # If a NudgeType, that class is removed to the list of types that can be used to generate
    # random code.
    def disable(item)
      if item.superclass == Instruction
        @instructions_library.delete(item)
      elsif item.include? NudgeType
        @types.delete(item)
      end
    end
    
    
    # Completely empties the set of active Instructions. The interpreter will recognize InstructionPoints,
    # but will not invoke their #go methods when it does.
    def disable_all_instructions
      @instructions_library = Hash.new
    end
    
    
    # Completely empties the set of NudgeTypes in play. ValuePoints the Interpreter encounters will
    # still be recognized in code, and will still be pushed to the appropriate stack, but new
    # ValuePoints (made by various code-generating methods) will not be created.
    def disable_all_types
      @types = []
    end
    
    
    # Create a new sensor with the given name, binding the associated block argument. All sensors are
    # called, in the order registered, when the Interpreter#run cycle terminates normally.
    def register_sensor(name, &block)
      raise(ArgumentError, "Sensor name #{name} is not a string") unless name.kind_of?(String)
      @sensors[name] = block
    end
    
    
    # Delete all sensors.
    def reset_sensors
      @sensors = Hash.new
    end
    
    
    # Iterates through the Interpreter#sensors hash, #calling each one and passing in the current state
    # of the Interpreter as an argument
    def fire_all_sensors
      @sensors.inject({}) do |result, (key, value)|
        result[key] = @sensors[key].call(self)
        result
      end
    end
  end
end