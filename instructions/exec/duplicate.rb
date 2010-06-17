class Instruction::ExecDuplicate < Instruction
  def process
    stack = @outcome_data.stacks[:exec]
    stack.push(stack.last)
  end
end
