module IfInstruction
  attr_reader :target_stack
  
  def initialize(context, target_stack)
    @target_stack = target_stack
    super(context)
  end
  
  def preconditions?
    needs @target_stack, 2
    needs :bool, 1
  end
  def setup
    @stay = @context.pop_value(:bool)
    @ifFalse = @context.pop(@target_stack)
    @ifTrue = @context.pop(@target_stack)
  end
  def derive
  end
  def cleanup
    @stay ? @context.stacks[@target_stack].push(@ifTrue) : @context.stacks[@target_stack].push(@ifFalse)
  end
end


class IntIfInstruction < Instruction
  include IfInstruction
  def initialize(context)
    super(context, :int)
  end
end


class FloatIfInstruction < Instruction
  include IfInstruction
  def initialize(context)
    super(context, :float)
  end
end


class ExecIfInstruction < Instruction
  include IfInstruction
  def initialize(context)
    super(context, :exec)
  end
end


class CodeIfInstruction < Instruction
  def preconditions?
    needs :code, 2
    needs :bool, 1
  end
  def setup
    @stay = @context.pop_value(:bool)
    @ifFalse = @context.pop_value(:code)
    @ifTrue = @context.pop_value(:code)
  end
  def derive
    which = @stay ? @ifTrue : @ifFalse
    @result = NudgeProgram.new(which).linked_code
  end
  def cleanup
    pushes :exec, @result
  end
  
end