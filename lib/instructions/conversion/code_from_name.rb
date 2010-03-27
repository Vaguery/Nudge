#encoding: utf-8

class CodeFromNameInstruction < Instruction
  def preconditions?
    needs :name, 1
  end
  def setup
    @arg = @context.pop(:name).name
  end
  def derive
    @result = ValuePoint.new("code", "ref #{@arg}")
  end
  def cleanup
    pushes :code, @result
  end
end
