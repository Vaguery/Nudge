class CodeNullQInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_listing = @context.pop_value(:code)
    @arg1 = NudgeProgram.new(arg_listing).listing
  end
  def derive
    @result = ValuePoint.new("bool", @arg1 == "block {}")
  end
  def cleanup
    pushes :bool, @result
  end
end
