class IntModuloInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
    if @arg2 != 0
      @mod = @arg1 % @arg2
      @result = ValuePoint.new("int", @mod)
    else
      raise InstructionMethodError, "#{self.class} cannot calculate modulo 0"
    end
  end
  def cleanup
    pushes :int, @result
  end
end
