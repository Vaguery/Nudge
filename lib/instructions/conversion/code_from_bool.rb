#encoding: utf-8

class CodeFromBoolInstruction < Instruction
  def preconditions?
    needs :bool, 1
  end
  def setup
    @arg = @context.pop_value(:bool)
  end
  def derive
    @result = ValuePoint.new("code", "value «bool»\n«bool» #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end
