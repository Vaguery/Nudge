class Instruction::ExecPop < Instruction
  def process
    @outcome_data.stacks[:exec].pop
  end
end
