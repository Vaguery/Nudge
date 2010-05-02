# pushes a new +:code+ item whose value is a block containing one call to every
# Instruction active in the context
#
# note: the order of instructions is determined by the order they appear in the context's library
#
# *needs:* nothing
#
# *pushes:* 1 +:code+

class CodeInstructionsInstruction < Instruction
  def preconditions?
    true
  end
  
  def setup
  end
  
  def derive
    all_instructions = @context.instructions
    list_as_block = all_instructions.inject("block {") {|b,i| b + " do #{i.to_nudgecode}"} + "}"
    @result = ValuePoint.new("code", list_as_block)
  end
  
  def cleanup
    pushes :code, @result
  end
end
