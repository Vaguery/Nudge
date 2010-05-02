#encoding: utf-8

# Pops one "count" item from the +:int+ stack, and one item from the +:exec+ stack.
# The net effect of the instruction (unless interfered with by another operation)
# is to evaluate the +:exec+ item "count" times.
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
# where +popped item+ is the code from the +:exec+ stack, and +count - 1+ is a decrement of
# the "count" value.
#
# *needs:* ExecDoRangeInstruction must be active in the context for this to work; needs 1 +:int+ and 1 +:exec+ item
#
# *pushes:* it's complicated...
#

class ExecDoCountInstruction < Instruction
  def preconditions?
    needs ExecDoRangeInstruction
    needs :exec, 1
    needs :int, 1
  end
  
  def setup
    @destination = @context.pop(:int)
    @code = @context.pop(:exec)
  end
  
  def derive
    raise InstructionMethodError, "#{self.class} needs a positive argument" if @destination.value < 1
    @one_less = ValuePoint.new("int",@destination.value-1)
  end
  
  def cleanup
    recursor = CodeblockPoint.new([ValuePoint.new("int",0), @one_less,
      InstructionPoint.new("exec_do_range"),@code])
    pushes :exec, recursor
  end
end