class CodeQuoteInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  def setup
    @arg = @context.pop(:exec).listing
  end
  def derive
    @result = ValuePoint.new("code", @arg)
  end
  def cleanup
    pushes :code, @result
  end
end
