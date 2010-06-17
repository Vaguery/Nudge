class Instruction::IntPop < Instruction
  def process
    @outcome_data.stacks[:int].pop
  end
end
