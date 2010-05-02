# pops the top item of the +:code+ stack;
# pushes a ValuePoint onto the +:bool+ stack that is +false+ only if the +:code+ item was a CodeBlockPoint,
# (that is, a multi-line Nudge program)
#
# *needs:* 1 +:code+
#
# *pushes:* 1 +:bool+
#

class CodeAtomQInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    arg_blueprint = @context.pop_value(:code)
    @arg1 = NudgeProgram.new(arg_blueprint)
  end
  def derive
    atomQ = @arg1.parses? && @arg1.points == 1
    @result = ValuePoint.new("bool", atomQ)
  end
  def cleanup
    pushes :bool, @result
  end
end
