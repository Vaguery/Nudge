class Instruction::BoolFlush < Instruction
  def process
    @outcome_data.stacks[:bool].clear
  end
end
