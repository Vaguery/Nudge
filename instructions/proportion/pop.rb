class Instruction::ProportionPop < Instruction
  def process
    @outcome_data.stacks[:proportion].pop
  end
end
