class CodePointsInstruction < Instruction
  
  def preconditions?
    needs :code, 1
  end
  
  def setup
    arg_blueprint = @context.pop_value(:code)
    @parsed = NudgeProgram.new(arg_blueprint)
  end
  
  def derive
    @result = ValuePoint.new("int",@parsed.points)
  end
  
  def cleanup
    pushes :int, @result
  end
end
