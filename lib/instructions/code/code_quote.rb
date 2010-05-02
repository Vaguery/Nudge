# pops the top +:exec+ item;
# pushes a new +:code+ item that has that value
#
# *needs:* 1 +:exec+
#
# *pushes:* 1 +:code+


class CodeQuoteInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  
  def setup
    @arg = @context.pop(:exec).blueprint
  end
  
  def derive
    @result = ValuePoint.new("code", @arg)
  end
  
  def cleanup
    pushes :code, @result
  end
end
