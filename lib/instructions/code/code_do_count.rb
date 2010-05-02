# Pops one "count" item from the +:int+ stack, and one item from the +:code+ stack.
# The net effect of the instruction (unless interfered with by another operation)
# is to evaluate the +:code+ item "count" times.
#
# If the count is negative, an +:error+ item will be pushed to the +:error+ stack. Otherwise,
# a ValuePoint containing the following "macro" is created and pushed onto the +:exec+ stack:
#   block {
#     value «int»
#     value «int»
#     do exec_do_range
#     popped item
#   }
#   «int» 0
#   «int» count - 1
# where +popped_item+ is the code from the +:code+ stack, and +count - 1+ is a decrement of
# the "count" value.
#
# *needs:* ExecDoRangeInstruction must be active in the context for this to work; needs 1 +:int+ and 1 +:code+ item
#
# *pushes:* it's complicated...
#

class CodeDoCountInstruction < Instruction
  def preconditions?
    needs ExecDoRangeInstruction
    needs :code, 1
    needs :int, 1
  end
  
  def setup
    @destination = @context.pop(:int)
    @code = @context.pop_value(:code)
    raise InstructionMethodError,
      "#{self.class.to_nudgecode} needs a positive argument" if @destination.value < 1
  end
  
  def derive
    @codeblock = NudgeProgram.new(@code).linked_code
    @one_less = ValuePoint.new("int",@destination.value-1)
  end
  
  def cleanup
    recursor = CodeblockPoint.new([ValuePoint.new("int",0), @one_less,
      InstructionPoint.new("exec_do_range"),@codeblock])
    pushes :exec, recursor
  end
end
