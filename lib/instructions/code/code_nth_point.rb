# pops the top +:code+ item and +:int+ item ("N");
# pushes a new +:code+ item containing the Nth program point of the +:code+
#
# If the +:code+ is not a block, it's replaced intact;
# if the +:code+ value cannot be parsed, an +:error+ is pushed instead of a +:code+ item;
# otherwise, the index is chosen as +N+ modulo the length of the number of program points.
#
# *needs:* 1 +:code+ and 1 +:int+
#
# *pushes:* 1 +:code+
#

class CodeNthPointInstruction < Instruction # was CODE.EXTRACT in Push3
  def preconditions?
    needs :int, 1
    needs :code, 1
  end
  
  def setup
    @arg1 = @context.pop_value(:int)
    @arg2 = @context.pop_value(:code)
  end
  
  def derive
    tree = NudgeProgram.new(@arg2)
    tree_size = tree.points
    raise InstructionMethodError, "#{self.class} divied by zero" if tree_size < 1
    which = (@arg1-1) % tree_size + 1
    pt = tree[which]
    @result = ValuePoint.new("code", pt.blueprint)
  end
  
  def cleanup
    pushes :code, @result
  end
end
