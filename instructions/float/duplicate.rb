class Instruction::FloatDuplicate < Instruction
  def process
    stack = @outcome_data.stacks[:float]
    stack.push(stack.last)
  end
end
