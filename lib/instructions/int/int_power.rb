class IntPowerInstruction < Instruction
  def preconditions?
    needs :int, 2
  end
  def setup
    @arg2 = @context.pop_value(:int)
    @arg1 = @context.pop_value(:int)
  end
  def derive
    raise NaNResultError,"#{self.class} attempted negative root of 0" if @arg1 == 0 && @arg2 < 0
    @result = ValuePoint.new("int", (@arg1**@arg2).to_i)
  end
  def cleanup
    pushes :int, @result
  end
end
