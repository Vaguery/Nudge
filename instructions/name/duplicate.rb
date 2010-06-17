class Instruction::NameDuplicate < Instruction
  def process
    stack = @outcome_data.stacks[:name]
    stack.push(stack.last)
  end
end
