class ExecEqualQInstruction < Instruction
  def preconditions?
    needs :exec, 2
  end
  def setup
    @arg2 = @context.pop(:exec).listing
    @arg1 = @context.pop(:exec).listing
  end
  def derive
    x1 = NudgeProgram.new(@arg1)
    x2 = NudgeProgram.new(@arg2)
    @result = ValuePoint.new("bool", x1.listing == x2.listing)
  end
  def cleanup
    pushes :bool, @result
  end
end
