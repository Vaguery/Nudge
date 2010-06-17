class Instruction::FloatPop < Instruction
  def process
    @outcome_data.stacks[:float].pop
  end
end
