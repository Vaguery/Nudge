# pops the top +:code+ item;
# pushes a new +:bool+ item with value +true+ if the +:code+ is an empty block
#
# *needs:* 1 +:code+
#
# *pushes:* 1 +:bool+
#

class CodeNullQInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  
  def setup
    arg_blueprint = @context.pop_value(:code)
    @arg1 = NudgeProgram.new(arg_blueprint).blueprint
  end
  
  def derive
    @result = ValuePoint.new("bool", @arg1 == "block {}")
  end
  
  def cleanup
    pushes :bool, @result
  end
end
