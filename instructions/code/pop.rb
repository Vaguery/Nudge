class Instruction::CodePop < Instruction
  def process
    @outcome_data.stacks[:code].pop
  end
end
