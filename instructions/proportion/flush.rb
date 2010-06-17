class Instruction::ProportionFlush < Instruction
  def process
    @outcome_data.stacks[:proportion].clear
  end
end
