class Instruction::CodeDepth < Instruction
  def process
    put :int, @outcome_data.stacks[:code].length
  end
end
