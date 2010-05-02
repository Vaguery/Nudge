# pops the top +:code+ item and +:int+ item ("N");
# pushes a new +:code+ item containing the Nth backbone element of the +:code+, if it's a block
#
# If the +:code+ is not a block, it's replaced intact;
# if the +:code+ is an empty block, an +:error+ is pushed instead of a +:code+ item;
# otherwise, the index is chosen as +N+ modulo the length of the block's backbone.
#
# *needs:* 1 +:code+ and 1 +:int+
#
# *pushes:* 1 +:code+
#

class CodeNthInstruction < Instruction 
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
    if tree.linked_code.kind_of?(CodeblockPoint)
      pts = tree[1].contents.length
      raise InstructionMethodError, "#{self.class} can't work on empty blocks" if pts < 1
      val = tree[1].contents[@arg1 % pts]
    else
      val = tree
    end
    @result = ValuePoint.new("code", val.blueprint)
  end
  def cleanup
    pushes :code, @result
  end
end
