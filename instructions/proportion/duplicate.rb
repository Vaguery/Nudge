class Instruction::ProportionDuplicate < Instruction
  def process
    stack = @outcome_data.stacks[:proportion]
    stack.push(stack.last)
  end
end
