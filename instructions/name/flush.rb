class Instruction::NameFlush < Instruction
  def process
    @outcome_data.stacks[:name].clear
  end
end
