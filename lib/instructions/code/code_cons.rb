# pops the top 2 items from the +:code+ stack;
# pushes a new +:code+ item containing a block, obtained by +cons+ing the other listings, a la Lisp
#
# note: order matters, and the top stack item is the second argument, the second stack item is the first
#
# If the second argument is a block, the result is obtained by inserting the first argument
# into that block as the new first element; if the second argument isn't a block, it's first
# wrapped in one, and then the first argument is inserted into that block.
#
# For example:
#   first_argument + second_argument -> cons result
#   [a, b] + [1,2,3] -> [[a,b],1,2,3]
#   [a,b] + 1 -> [[a,b],1]
#   a + [1,2,3] -> [a,1,2,3]
#   a + 1 -> [a,1]
#
# note: there are several differences between this and +code_concatenate+
#
# *needs:* 2 +:code+
#
# *pushes:* 1 +:code+
#

class CodeConsInstruction < Instruction
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
      consed_tree = t2.insert_point_before(1,t1.linked_code)
    else
      raise InstructionMethodError,
        "#{self.class.to_nudgecode} cannot parse the arguments"
    end
    @result = ValuePoint.new("code", consed_tree.blueprint)
  end
  def cleanup
    pushes :code, @result
  end
end
