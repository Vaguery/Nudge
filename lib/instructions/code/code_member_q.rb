# pops the top 2 item of the +:code+ stack;
# pushes a new ValuePoint onto the +:bool+ stack, with value +true+ if the
# second argument appears as a block in the _backbone_ of the first argument
#
# note: order matters, and the top stack item is the second argument, the second stack item is the first
#
# note: compare to CodeContainsQInstruction, which checks for matches at all subtrees, not just the "root"
#
# *needs:* 2 +:code+
#
# *pushes:* 1 +:bool+
#


class CodeMemberQInstruction < Instruction
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
      if tree.linked_code.kind_of?(CodeblockPoint)
        found = tree[1].contents.any? {|branch| branch.blueprint == looking_for_this.blueprint}
      else
        found = (tree.blueprint == looking_for_this.blueprint)
      end
    else
      found = false
    end
    @result = ValuePoint.new("bool", found)
  end
  def cleanup
    pushes :bool, @result
  end
end
