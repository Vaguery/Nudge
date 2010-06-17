class Instruction::CodeFlush < Instruction
  def process
    @outcome_data.stacks[:code].clear
  end
end
