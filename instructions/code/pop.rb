class CodePop < NudgeInstruction
  def process
    @outcome_data.stacks[:code].pop
  end
end
