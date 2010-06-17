class Instruction::NamePop < Instruction
  def process
    @outcome_data.stacks[:name].pop
  end
end
