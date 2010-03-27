class BoolFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = @context.pop_value(:int)
  end
  def derive
    @result = ValuePoint.new("bool", @arg != 0)
  end
  def cleanup
    pushes :bool, @result
  end
end
