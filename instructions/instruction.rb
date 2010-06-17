class Instruction
  def Instruction.inherited (klass)
    klass.const_set("REQUIREMENTS", {})
    
    def klass.get (n, type_id)
      self::REQUIREMENTS[type_id] = n
      
      self.module_eval <<-END
        def #{type_id} (n)
          @argument_stacks[:#{type_id}][n]
        end
      END
    end
  end
  
  def Instruction.execute (instruction_id, outcome_data)
    instruction = const_get(instruction_id.to_s.classify).new(outcome_data)
    stacks = outcome_data.stacks
    
    if instruction.get_required_arguments!(stacks)
      instruction.process
      instruction.push_results_to_stacks!(stacks)
    end
  end
  
  def initialize (outcome_data)
    @outcome_data = outcome_data
    @argument_stacks = {}
    @result_stacks = {}
  end
  
  def put (type_id, result)
    result_stack = @result_stacks[type_id] ||= []
    result_stack << (type_id == :exec ? result : result.to_s)
  end
  
  def get_required_arguments! (stacks)
    self.class::REQUIREMENTS.each do |type_id, n|
      if !(stack = stacks[type_id]) || (stack.length < n)
        return false
      end
    end.each do |type_id, n|
      stack = stacks[type_id]
      argument_stack = @argument_stacks[type_id] ||= []
      
      n.times do
        argument_stack << (type_id == :exec ? stack.pop : stack.pop.send(:"to_#{type_id}"))
      end
    end
  end
  
  def push_results_to_stacks! (stacks)
    @result_stacks.each do |type_id, result_stack|
      stack = stacks[type_id]
      
      result_stack.each do |result|
        stack.push(result)
      end
    end
  end
end
