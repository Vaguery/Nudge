# Implements the Y Combinator on the +:exec+ stack:
# pops the top item from the +:exec+ stack, then
# pushes:
# * a CodeBlockPoint with the following macro:
#   block {
#     do exec_y
#     popped_item
#   }
# * the +popped_item+ (again)
# 
# The result is an (arguably infinite) recursive call of the +popped_item+; it will run once, then
# the macro will be encountered and the process will repeat.
#
# *needs:* 1 +:exec+ item
#
# *pushes:* 2 +:exec+ items


class ExecYInstruction < Instruction
  def preconditions?
    needs :exec, 1
  end
  def setup
    @arg1 = @context.pop(:exec)
  end
  def derive
    @recurser = CodeblockPoint.new([InstructionPoint.new("exec_y"),@arg1])
  end
  def cleanup
    pushes :exec, @recurser
    pushes :exec, @arg1
  end
end
