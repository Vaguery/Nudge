# pops the top item from the +:code+ stack;
# implements a equivalent to Lisp's +cdr+ function, treating Nudge blocks as lists:
#
# If the +:code+ value has at least 2 points (meaning it's a block with at least 1 element),
# the new code value is this block with its first element deleted; otherwise, the result is
# an empty block.
#
# *needs:* 1 +:code+
#
# *pushes:* 1 +:code+
#

class CodeCdrInstruction < Instruction
  def preconditions?
    needs :code, 1
  end
  def setup
    @arg = @context.pop_value(:code)
  end
  def derive
    tree = NudgeProgram.new(@arg)
    if tree.linked_code.kind_of?(CodeblockPoint) && (tree.points > 1)
      new_tree = tree.delete_point(2)
    else
      new_tree = CodeblockPoint.new([])
    end
    @result = ValuePoint.new("code", new_tree.blueprint)
  end
  def cleanup
    pushes :code, @result
  end
end
