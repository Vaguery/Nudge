class Instruction::ExecFlush < Instruction
  def process
    @outcome_data.stacks[:exec].clear
  end
end
