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
