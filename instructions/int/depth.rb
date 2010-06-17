class Instruction::IntDepth < Instruction
  def process
    put :int, @outcome_data.stacks[:int].length
  end
end
