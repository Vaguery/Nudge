class Instruction::ExecDepth < Instruction
  def process
    put :int, @outcome_data.stacks[:exec].length
  end
end
