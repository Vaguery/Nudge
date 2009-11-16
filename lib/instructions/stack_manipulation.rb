class IntPopInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @result = @context.stacks[:int].pop
  end
  def derive
  end
  def cleanup
  end
end



class FloatPopInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @result = @context.stacks[:float].pop
  end
  def derive
  end
  def cleanup
  end
end



class IntSwapInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @result1 = @context.stacks[:int].pop
    @result2 = @context.stacks[:int].pop
  end
  def derive
  end
  def cleanup
    pushes :int, @result1
    pushes :int, @result2
  end
end



class FloatSwapInstruction < Instruction
  def preconditions?
    needs :float, 2
  end
  def setup
    @result1 = @context.stacks[:float].pop
    @result2 = @context.stacks[:float].pop
  end
  def derive
  end
  def cleanup
    pushes :float, @result1
    pushes :float, @result2
  end
end



class IntDuplicateInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg1 = @context.stacks[:int].peek.value
  end
  def derive
    @result = LiteralPoint.new("int",@arg1)
  end
  def cleanup
    pushes :int, @result
  end
end



class FloatDuplicateInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg1 = @context.stacks[:float].peek.value
  end
  def derive
    @result = LiteralPoint.new("float",@arg1)
  end
  def cleanup
    pushes :float, @result
  end
end




class IntRotateInstruction < Instruction
  def preconditions?
    needs :int, 3
  end
  def setup
    @arg3 = @context.stacks[:int].pop
    @arg2 = @context.stacks[:int].pop
    @arg1 = @context.stacks[:int].pop
  end
  def derive
  end
  def cleanup
    pushes :int, @arg2
    pushes :int, @arg3
    pushes :int, @arg1
  end
end



class FloatRotateInstruction < Instruction
  def preconditions?
    needs :float, 3
  end
  def setup
    @arg3 = @context.stacks[:float].pop
    @arg2 = @context.stacks[:float].pop
    @arg1 = @context.stacks[:float].pop
  end
  def derive
  end
  def cleanup
    pushes :float, @arg2
    pushes :float, @arg3
    pushes :float, @arg1
  end
end




class IntDepthInstruction < Instruction
  def preconditions?
    @context.stacks[:int].depth != nil
  end
  def setup
  end
  def derive
    @result = LiteralPoint.new("int",@context.stacks[:int].depth)
  end
  def cleanup
    pushes :int, @result
  end
end



class FloatDepthInstruction < Instruction
  def preconditions?
    @context.stacks[:float].depth != nil
  end
  def setup
  end
  def derive
    @result = LiteralPoint.new("int",@context.stacks[:float].depth)
  end
  def cleanup
    pushes :int, @result
  end
end




class IntFlushInstruction < Instruction
  def preconditions?
    @context.stacks[:int].depth != nil
  end
  def setup
  end
  def derive
  end
  def cleanup
    @context.stacks[:int].clear
  end
end



class FloatFlushInstruction < Instruction
  def preconditions?
    @context.stacks[:float].depth != nil
  end
  def setup
  end
  def derive
  end
  def cleanup
    @context.stacks[:float].clear
  end
end
