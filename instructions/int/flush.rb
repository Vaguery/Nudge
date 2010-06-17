class Instruction::IntFlush < Instruction
  def process
    @outcome_data.stacks[:int].clear
  end
end
