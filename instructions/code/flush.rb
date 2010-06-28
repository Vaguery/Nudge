class CodeFlush < NudgeInstruction
  def process
    @outcome_data.stacks[:code].clear
  end
end
