class Instruction::BoolDuplicate < Instruction
  def process
    stack = @outcome_data.stacks[:bool]
    stack.push(stack.last)
  end
end
