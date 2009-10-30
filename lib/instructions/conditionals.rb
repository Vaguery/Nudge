class IntIfInstruction < Instruction
  def preconditions?
    needs :int, 1
    needs :bool, 1
  end
  def setup
    @stay = @context.stacks[:bool].pop.value
  end
  def derive
  end
  def cleanup
    if !@stay
      @context.stacks[:int].pop
    end
  end
end


class FloatIfInstruction < Instruction
  def preconditions?
    needs :float, 1
    needs :bool, 1
  end
  def setup
    @stay = @context.stacks[:bool].pop.value
  end
  def derive
  end
  def cleanup
    if !@stay
      @context.stacks[:float].pop
    end
  end
end
