class Instruction::BoolPop < Instruction
  def process
    @outcome_data.stacks[:bool].pop
  end
end
