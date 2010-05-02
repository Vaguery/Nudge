# pops the top 2 item of the +:code+ stack;
# pushes a new ValuePoint onto the +:bool+ stack, with value +true+ if the
# second argument appears as a sub-block anywhere in the first argument
#
# note: order matters, and the top stack item is the second argument, the second stack item is the first
#
# *needs:* 2 +:code+
#
# *pushes:* 1 +:bool+
#

class CodeContainsQInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    looking_for_this = NudgeProgram.new(@arg1)
    tree = NudgeProgram.new(@arg2)
    if tree.parses? && looking_for_this.parses?
      found = tree.linked_code.any? {|point| point.blueprint == looking_for_this.blueprint}
    else
      found = false
    end
    @result = ValuePoint.new("bool", found)
  end
  def cleanup
    pushes :bool, @result
  end
end
