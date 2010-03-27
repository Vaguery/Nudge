class CodeEqualQInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    c1 = NudgeProgram.new(@arg1).listing
    c2 = NudgeProgram.new(@arg2).listing
    @result = ValuePoint.new("bool", c1 == c2)
  end
  def cleanup
    pushes :bool, @result
  end
end
