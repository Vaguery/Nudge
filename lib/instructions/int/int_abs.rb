class IntAbsInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg1 = @context.pop_value(:int)
  end
  def derive
      @result = ValuePoint.new("int", @arg1.abs)
  end
  def cleanup
    pushes :int, @result
  end
end
