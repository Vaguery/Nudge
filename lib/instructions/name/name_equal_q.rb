class NameEqualQInstruction < Instruction
  def preconditions?
    needs :name, 2
  end
  def setup
    @arg2 = @context.pop_value(:name)
    @arg1 = @context.pop_value(:name)
  end
  def derive
    @result = ValuePoint.new("bool", @arg1 == @arg2)
  end
  def cleanup
    pushes :bool, @result
  end
end
