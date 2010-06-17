class Instruction::FloatFlush < Instruction
  def process
    @outcome_data.stacks[:float].clear
  end
end
