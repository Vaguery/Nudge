class NamesNotEnabled < RuntimeError
end

module DefineInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    if @target_stack != :name
      needs @target_stack, 1
      needs :name, 1
    else
      needs :name, 2
    end
    # 
    # if @context.respond_to?(:bind_name)
    #   return true
    # else
    #   raise NamesNotEnabled
    #   return false
    # end
  end
  
  def setup
    @bound_name = @context.stacks[:name].pop.value
    @new_value = @context.stacks[@target_stack].pop
  end
  
  def derive
  end
  
  def cleanup
    @context.bind_name(@bound_name, @new_value)
  end
end


class IntDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :int)
  end
end


class BoolDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :bool)
  end
end


class FloatDefineInstruction < Instruction
  include DefineInstruction
  def initialize(context)
    super(context, :float)
  end
end
