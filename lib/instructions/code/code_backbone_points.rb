class CodeBackbonePointsInstruction < Instruction
  
  def preconditions?
    needs :code, 1
  end
  
  def setup
    arg_blueprint = @context.pop_value(:code)
    @parsed = NudgeProgram.new(arg_blueprint)
  end
  
  def derive
    if @parsed.parses?
      pts = @parsed.linked_code.kind_of?(CodeblockPoint) ? @parsed[1].contents.length : 0
    else
      pts = 0
    end
    @result = ValuePoint.new("int",pts)
  end
  
  def cleanup
    pushes :int, @result
  end
end
