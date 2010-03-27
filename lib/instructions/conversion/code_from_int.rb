#encoding: utf-8


class CodeFromIntInstruction < Instruction
  def preconditions?
    needs :int, 1
  end
  def setup
    @arg = @context.pop_value(:int)
  end
  def derive
    @result = ValuePoint.new("code", "value «int»\n«int» #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end
