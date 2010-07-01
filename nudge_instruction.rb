class String
  def to_instruction_class
    eval self.gsub('?','_q').
    gsub(/^([a-z\d])|_([a-z\d])/) {|s| s.upcase}.
    gsub(/_/,'')
  end
end

class NudgeInstruction
  INSTRUCTIONS = {}
  
  def self.to_nudge_symbol
    self.name.
    gsub(/^.*::/, '').
    gsub(/Q$/,'?').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    downcase.intern
  end
  
  def self.to_nudge_string
    self.to_nudge_symbol.to_s
  end
  
  
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
    instruction = INSTRUCTIONS[instruction_name].new(outcome_data)
    stacks = outcome_data.stacks
    
    if instruction.get_required_arguments!(stacks)
      instruction.process
      instruction.push_results_to_stacks!(stacks)
    end
    
  rescue NudgeError => error
    stacks[:error].push(error.string)
  end
  
  def initialize (outcome_data)
    @outcome_data = outcome_data
    @argument_stacks = {}
    @result_stacks = {}
  end
  
  def put (value_type, result)
    result_stack = @result_stacks[value_type] ||= []
    result_stack << (value_type == :exec ? result : result.to_s)
  end
  
  def get_required_arguments! (stacks)
    self.class::REQUIREMENTS.each do |value_type, n|
      if !(stack = stacks[value_type]) || (stack.length < n)
        return false
      end
    end.each do |value_type, n|
      stack = stacks[value_type]
      argument_stack = @argument_stacks[value_type] ||= []
      
      n.times do
        argument_stack << (value_type == :exec ? stack.pop : stack.pop.send(:"to_#{value_type}"))
      end
    end
  end
  
  def push_results_to_stacks! (stacks)
    @result_stacks.each do |value_type, result_stack|
      stack = stacks[value_type]
      
      result_stack.each do |result|
        stack.push(result)
      end
    end
  end
end
