# pops the top 2 items from the +:code+ stack;
# pushes a new +:code+ item containing a block obtained by combining the other listings into one block
#
# note: the top stack item (the "attachment") is the second item of the resulting list
#
# *needs:* 2 +:code+
#
# *pushes:* 1 +:code+
#

class CodeListInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    listed = []
    listed << NudgeProgram.new(@arg1).linked_code unless @arg1 == ""
    listed << NudgeProgram.new(@arg2).linked_code unless @arg2 == ""
    combined = CodeblockPoint.new(listed).blueprint
    @result = ValuePoint.new("code", combined)
  end
  def cleanup
    pushes :code, @result
  end
end
