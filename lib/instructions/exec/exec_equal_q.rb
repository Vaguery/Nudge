# pops the top 2 items of the +:exec+ stack;
# pushes a new ValuePoint onto the +:exec+ stack, with value +true+ if the
# two items' blueprint strings are identical
#
# *needs:* 2 +:exec+
#
# *pushes:* 1 +:bool+
#

class ExecEqualQInstruction < Instruction
  def preconditions?
    needs :exec, 2
  end
  def setup
    @arg2 = @context.pop(:exec).blueprint
    @arg1 = @context.pop(:exec).blueprint
  end
  def derive
    x1 = NudgeProgram.new(@arg1)
    x2 = NudgeProgram.new(@arg2)
    @result = ValuePoint.new("bool", x1.blueprint == x2.blueprint)
  end
  def cleanup
    pushes :bool, @result
  end
end
