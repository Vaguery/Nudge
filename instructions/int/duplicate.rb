class Instruction::IntDuplicate < Instruction
  def process
    stack = @outcome_data.stacks[:int]
    stack.push(stack.last)
  end
end
