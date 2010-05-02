# pops the top 2 items from the +:code+ stack;
# pushes a new +:code+ item containing a block obtained by concatenating the other listings
#
# note: the top stack item (the "attachment") is concatenated _into_ the second popped item (the "receiver")
#
# If both items are already blocks, the new block is their concatenation;
# if the receiver is a block and the attachment isn't, the attachment is appended to the receiver;
# if the receiver is not a block, then a _surrounding_ block is constructed that contains both, in order.
#
# For example:
#   [a, b] + [1,2,3] -> [a,b,1,2,3]
#   [a,b] + 1 -> [a,b,1]
#   a + [1,2,3] -> [a,[1,2,3]]
#   a + 1 -> [a,1]
#
# *needs:* 2 +:code+
#
# *pushes:* 1 +:code+
#

class CodeConcatenateInstruction < Instruction
  def preconditions?
    needs :code, 2
  end
  def setup
    @arg2 = @context.pop_value(:code)
    @arg1 = @context.pop_value(:code)
  end
  def derive
    t1 = NudgeProgram.new(@arg1)
    t2 = NudgeProgram.new(@arg2)
    if t1.parses? && t2.parses?
      if t1.linked_code.kind_of?(CodeblockPoint)
        if t2.linked_code.kind_of?(CodeblockPoint)
          new_tree = t1[1].contents + t2[1].contents
        else
          new_tree = t1[1].contents << t2.linked_code
        end
      else
        new_tree = [t1.linked_code, t2.linked_code]
      end
      listed = CodeblockPoint.new(new_tree).blueprint
      @result = ValuePoint.new("code", listed)
    else
      @result = ValuePoint.new("code", "block {}")
    end
  end
  def cleanup
    pushes :code, @result
  end
end
