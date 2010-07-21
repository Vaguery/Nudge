class NudgeInstruction
  INSTRUCTIONS = {}
  
  def NudgeInstruction.inherited (klass)
    klass.const_set("REQUIREMENTS", {})
    
    instruction_name = klass.name.
      gsub(/^.*::/, '').
      gsub(/Q$/,'?').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      downcase.intern
    
    INSTRUCTIONS[instruction_name] = klass
    
    def klass.get (n, value_type)
      self::REQUIREMENTS[value_type] = n
      
      self.module_eval <<-END
        def #{value_type} (n)
          @argument_stacks[:#{value_type}][n]
        end
      END
    end
  end
  
  def NudgeInstruction.execute (instruction_name, outcome_data)
    INSTRUCTIONS[instruction_name].new(outcome_data).execute
  end
  
  def initialize (outcome_data)
    @outcome_data = outcome_data
    @argument_stacks = Hash.new {|hash, key| hash[key] = [] }
    @result_stacks = Hash.new {|hash, key| hash[key] = [] }
  end
  
  def execute
    stacks = @outcome_data.stacks
    
    self.class::REQUIREMENTS.each do |value_type, n|
      return unless (stack = stacks[value_type]) && (stack.length >= n)
    end.each do |value_type, n|
      stack = stacks[value_type]
      argument_stack = @argument_stacks[value_type]
      
      n.times do
        argument = (value_type == :exec) ? stack.pop : stack.pop.send(:"to_#{value_type}")
        argument_stack << argument
      end
    end
    
    process
    
    @result_stacks.each do |value_type, result_stack|
      stacks[value_type].concat result_stack
    end
    
  rescue NudgeError => error
    stacks[:error] << error.string
  end
  
  def put (value_type, result)
    result = (value_type == :exec) ? result : result.to_s
    @result_stacks[value_type] << result
  end
end
