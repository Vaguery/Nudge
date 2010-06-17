class Instruction::CodeDuplicate < Instruction
  def process
    stack = @outcome_data.stacks[:code]
    stack.push(stack.last)
  end
end
