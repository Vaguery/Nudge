# pops the top item from the +:code+ stack;
# implements a equivalent to Lisp's +car+ function, treating Nudge blocks as lists:
#
# If the +:code+ value has at least two points (meaning it's a block with at least 1 element),
# the new code value is the blueprint of the first element of that block; otherwise the "new"
# code is the original item's blueprint. A new +:code+ ValuePoint is created with this value and pushed.
#
# *needs:* 1 +:code+
#
# *pushes:* 1 +:code+
#

class CodeCarInstruction < Instruction
  def preconditions?
    needs :code, 1
  end

  def setup
    @arg = @context.pop_value(:code)
  end

  def derive
    tree = NudgeProgram.new(@arg)
    if tree.linked_code.kind_of?(CodeblockPoint) && (tree.points > 2)
      new_tree = tree[1].contents[0]
    else
      new_tree = tree
    end
    @result = ValuePoint.new("code", new_tree.blueprint)
  end

  def cleanup
    pushes :code, @result
  end
end
