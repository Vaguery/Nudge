#encoding: utf-8

class CodeFromFloatInstruction < Instruction
  def preconditions?
    needs :float, 1
  end
  def setup
    @arg = @context.pop_value(:float)
  end
  def derive
    @result = ValuePoint.new("code", "value «float»\n«float» #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end
