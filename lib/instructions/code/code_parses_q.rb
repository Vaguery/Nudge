# pops the top +:code+ item;
# pushes a new +:bool+ with value +true+ if the +:code+ can be parsed
#
# *needs:* 1 +:code+
#
# *pushes:* 1 +:bool+
#

class CodeParsesQInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    @arg1 = @context.pop_value(:code)
  end
  def derive
    answer = NudgeProgram.new(@arg1).parses? ? true : false
    @result = ValuePoint.new("bool", answer)
  end
  def cleanup
    pushes :bool, @result
  end
end
